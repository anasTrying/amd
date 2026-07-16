/* =========================================================================
   وضّح — محرك مطابقة هوية التاجر (engine.js)
   -------------------------------------------------------------------------
   حتمي بالكامل: تطبيع نصي → تشابه ثنائيات الحروف → درجة ثقة.
   لا نداءات شبكة ولا نماذج لغوية وقت التشغيل — كل الذكاء محسوب مسبقًا
   داخل wathq-data.js (المرادفات + بيانات واثق).
   ========================================================================= */

const WadhahEngine = (() => {

  /* كلمات قانونية/حشو تُحذف قبل المقارنة (لاتيني + عربي) */
  const STOP_TOKENS = new Set([
    "co", "company", "llc", "ltd", "inc", "est", "corp",
    "trading", "trd", "trad", "for", "the", "of", "and",
    "sa", "ksa", "saudi", "arabia", "riyadh", "jeddah", "dammam",
    "شركة", "مؤسسة", "محل", "محلات", "متجر",
    "للتجارة", "التجارية", "التجاري", "المحدودة", "القابضة",
    "الرياض", "جدة", "الدمام"
  ]);

  /* توحيد الأشكال العربية المتقاربة ثم تنظيف عام */
  function normalize(input) {
    if (!input) return "";
    let s = String(input).toLowerCase();
    s = s
      .replace(/[أإآ]/g, "ا")
      .replace(/ى/g, "ي")
      .replace(/ة/g, "ه")
      .replace(/ـ/g, "")           // التطويل
      .replace(/[\u064B-\u0652]/g, ""); // التشكيل
    s = s.replace(/[^\p{L}\p{N}\s]/gu, " "); // إزالة الرموز والأرقام تبقى
    const tokens = s.split(/\s+/).filter(t => t && !STOP_TOKENS.has(t));
    return tokens.join(" ").trim();
  }

  /* ثنائيات الحروف لسلسلة مطبعة */
  function bigrams(s) {
    const joined = s.replace(/\s+/g, " ");
    const grams = [];
    for (let i = 0; i < joined.length - 1; i++) grams.push(joined.slice(i, i + 2));
    return grams;
  }

  /* معامل دايس: 2×المشترك ÷ مجموع الثنائيات — يتسامح مع الأخطاء الإملائية */
  function diceSimilarity(a, b) {
    if (!a || !b) return 0;
    if (a === b) return 1;
    const ga = bigrams(a), gb = bigrams(b);
    if (!ga.length || !gb.length) return 0;
    const counts = new Map();
    for (const g of ga) counts.set(g, (counts.get(g) || 0) + 1);
    let overlap = 0;
    for (const g of gb) {
      const c = counts.get(g) || 0;
      if (c > 0) { overlap++; counts.set(g, c - 1); }
    }
    return (2 * overlap) / (ga.length + gb.length);
  }

  /* احتواء كامل لأحد الطرفين في الآخر (بعد التطبيع) → إشارة قوية.
     يُشترط ألا يكون الطرف الأقصر كلمة قصيرة عامة (أقل من 5 أحرف)
     حتى لا تطابق كلمات مثل "قهوة" وحدها اسم تاجر كامل. */
  function containment(a, b) {
    if (!a || !b) return false;
    const shorter = a.length <= b.length ? a : b;
    if (shorter.length < 5) return false;
    return a.includes(b) || b.includes(a);
  }

  /* أفضل مرادف لتاجر معيّن مقابل مدخل مطبع */
  function bestAliasScore(merchant, normalizedInput) {
    const candidates = [
      merchant.legalName, merchant.displayName, ...(merchant.aliases || [])
    ];
    let best = { score: 0, alias: null };
    for (const c of candidates) {
      const nc = normalize(c);
      if (!nc) continue;
      let score = diceSimilarity(normalizedInput, nc);
      if (containment(normalizedInput, nc)) score = Math.max(score, 0.93);
      if (score > best.score) best = { score, alias: c };
    }
    return best;
  }

  /* المطابقة الرئيسية: وصف خام → أفضل تاجر مع درجة ثقة وإشارات */
  function match(rawDescriptor) {
    const normalizedInput = normalize(rawDescriptor);
    if (!normalizedInput) return null;

    let winner = null;
    for (const m of WATHQ_MERCHANTS) {
      const { score, alias } = bestAliasScore(m, normalizedInput);
      if (!winner || score > winner.score) winner = { merchant: m, score, alias };
    }
    if (!winner || winner.score < 0.55) return null;

    /* درجة الثقة: التشابه أساسًا، وسقفها أعلى للسجلات الموثقة من واثق */
    const cap = winner.merchant.source === "wathq" ? 0.97 : 0.88;
    const confidence = Math.round(Math.min(winner.score, cap) * 100);

    return {
      merchant: winner.merchant,
      confidence,
      matchedAlias: winner.alias,
      normalizedInput,
      verified: winner.merchant.source === "wathq"
    };
  }

  /* بحث داخل نص حر: نجرب النص كاملًا، ثم ما بين الأقواس، ثم نوافذ كلمات */
  function matchFromText(freeText) {
    const direct = match(freeText);
    if (direct && direct.confidence >= 62) return direct;

    const brackets = freeText.match(/[（(]([^）)]+)[）)]/g) || [];
    for (const b of brackets) {
      const inner = b.slice(1, -1);
      const r = match(inner);
      if (r) return r;
    }

    const words = normalize(freeText).split(" ");
    let best = null;
    for (let size = Math.min(4, words.length); size >= 1; size--) {
      for (let i = 0; i + size <= words.length; i++) {
        const window = words.slice(i, i + size).join(" ");
        const r = match(window);
        if (r && (!best || r.confidence > best.confidence)) best = r;
      }
      if (best && best.confidence >= 70) break;
    }
    return best;
  }

  return { normalize, match, matchFromText, diceSimilarity };
})();
