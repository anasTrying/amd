/* =========================================================================
   وضّح — /api/chat (Vercel Serverless Function)
   -------------------------------------------------------------------------
   وسيط آمن بين المحاكي وOpenAI: المفتاح يعيش في متغير البيئة
   OPENAI_API_KEY على Vercel فقط — لا يصل للمتصفح ولا للمستودع أبدًا.

   المحرك الحتمي في الواجهة يبقى المسار الأول (بطاقات الهوية الموثقة)؛
   هذه الدالة تجيب فقط على الأسئلة الحرة التي لا تطابق تاجرًا في الجدول.
   ========================================================================= */

const SYSTEM_PROMPT = `أنت "وضّح"، مساعد بنكي ذكي داخل تطبيق البنك في السعودية، تشارك في عرض تجريبي لهاكاثون أمد.
مهمتك: تفسير عمليات كشف الحساب، الرسوم، والاشتراكات بلغة عربية واضحة ومختصرة.

حقائق عن النظام الذي تعمل ضمنه:
- هوية التجار تُوثَّق من منصة واثق (السجل التجاري — وزارة التجارة)، وتُعرض في بطاقات موثقة تشمل رقم السجل والنشاط وموقع نقطة البيع.
- تجار العرض التجريبي الموثقون: أدرس كافيه (مقهى، الرياض)، صيدلية النهدي (جدة)، محطات الدريس (وقود، الرياض)، هنقرستيشن (توصيل، الرياض)، سوبرماركت أسواق النخبة/ثمار التنمية (الرياض)، آبل (خدمات إلكترونية).
- إذا سُئلت عن عملية لتاجر غير معروف: اشرح أن الاسم في الكشف غالبًا هو الاسم القانوني للتاجر لا اسمه التجاري، وأن النسخة الكاملة توثقه تلقائيًا من واثق.

قواعدك:
- أجب بلغة سؤال العميل (العربية افتراضًا)، بإيجاز (٣ جمل كحد أقصى)، وبنبرة ودودة مهنية.
- ستصلك قائمة عمليات حساب العميل الحالية — اعتمد عليها في أي سؤال عن العمليات أو المبالغ أو المجاميع.
- إذا حُدِّدت "عملية محل الاستفسار" فهي المقصودة بأي سؤال غامض أو ضمير (ليش؟ كم؟ متى؟ وينها؟ هالعملية) — أجب عنها هي تحديدًا ولا تخلط بينها وبين عمليات أخرى إلا إذا سأل العميل عن غيرها صراحةً أو عن حسابه كله.
- قبل أي جواب حسابي أو ترتيبي (مجموع، أكبر، ثاني أكبر…) رتّب القيم واحسب خطوة بخطوة داخليًا، ثم أعط الجواب النهائي فقط وتأكد أنه متسق مع القائمة.
- تابع سياق المحادثة السابقة إن وُجدت — أسئلة المتابعة تعود لآخر موضوع مطروح.
- لا تختلق أرقام سجلات تجارية أو مبالغ أو تواريخ غير موجودة في البيانات المعطاة.
- لا تطلب ولا تتعامل مع بيانات شخصية أو أرقام بطاقات.
- الأسئلة العامة خارج نطاق البنوك مرحب بها أيضًا: أجب عليها بإيجاز وودّية كمساعد ذكي شامل.`;

export default async function handler(req, res) {
  if (req.method !== "POST") {
    return res.status(405).json({ error: "method-not-allowed" });
  }

  const key = process.env.OPENAI_API_KEY;
  if (!key) {
    // المفتاح غير مضبوط — الواجهة تتعامل مع هذا بالرجوع للرد الافتراضي
    return res.status(503).json({ error: "ai-not-configured" });
  }

  const { message, context, focus, history } = req.body || {};
  if (!message || typeof message !== "string" || message.length > 500) {
    return res.status(400).json({ error: "bad-request" });
  }

  // الحدود تقصّ ولا تُسقط — إسقاط رد سابق طويل يفقد النموذج سياق المتابعة
  const messages = [{ role: "system", content: SYSTEM_PROMPT }];
  if (context && typeof context === "string") {
    messages.push({
      role: "system",
      content: "بيانات حساب العرض التجريبي كما تظهر في واجهة المحاكي الآن:\n" + context.slice(0, 6000)
    });
  }
  if (focus && typeof focus === "string") {
    messages.push({
      role: "system",
      content: "العملية محل الاستفسار — ضغط العميل زر (وضّح) بجانبها، فأي سؤال غامض يقصدها هي:\n" + focus.slice(0, 1200)
    });
  }
  if (Array.isArray(history)) {
    for (const h of history.slice(-8)) {
      if (h && (h.role === "user" || h.role === "assistant") &&
          typeof h.content === "string" && h.content.length > 0) {
        messages.push({ role: h.role, content: h.content.slice(0, 800) });
      }
    }
  }
  messages.push({ role: "user", content: message });

  try {
    const r = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: "Bearer " + key
      },
      body: JSON.stringify({
        model: "gpt-4o",
        temperature: 0.2,
        max_tokens: 300,
        messages
      })
    });

    if (!r.ok) {
      const detail = await r.text();
      console.error("openai error", r.status, detail.slice(0, 300));
      return res.status(502).json({ error: "upstream" });
    }

    const data = await r.json();
    const reply = data.choices?.[0]?.message?.content?.trim()?.slice(0, 2000);
    if (!reply) return res.status(502).json({ error: "empty-reply" });

    return res.status(200).json({ reply });
  } catch (e) {
    console.error("chat handler failed", e);
    return res.status(500).json({ error: "internal" });
  }
}
