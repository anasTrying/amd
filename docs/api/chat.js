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
- أجب بالعربية دائمًا، بإيجاز (٣ جمل كحد أقصى)، وبنبرة ودودة مهنية.
- ستصلك قائمة عمليات حساب العميل الحالية — اعتمد عليها في أي سؤال عن العمليات أو المبالغ أو المجاميع، واحسب بدقة.
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

  const { message, context } = req.body || {};
  if (!message || typeof message !== "string" || message.length > 500) {
    return res.status(400).json({ error: "bad-request" });
  }

  const messages = [{ role: "system", content: SYSTEM_PROMPT }];
  if (context && typeof context === "string" && context.length <= 6000) {
    messages.push({
      role: "system",
      content: "بيانات حساب العرض التجريبي كما تظهر في واجهة المحاكي الآن:\n" + context
    });
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
        model: "gpt-4o-mini",
        temperature: 0.4,
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
    const reply = data.choices?.[0]?.message?.content?.trim();
    if (!reply) return res.status(502).json({ error: "empty-reply" });

    return res.status(200).json({ reply });
  } catch (e) {
    console.error("chat handler failed", e);
    return res.status(500).json({ error: "internal" });
  }
}
