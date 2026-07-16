/* =========================================================================
   وضّح — الجدول المرجعي للتجار (wathq-data.js)
   -------------------------------------------------------------------------
   source: "wathq" → بيانات حقيقية مسحوبة من واثق (fullinfo)، حقول الهوية
   التجارية فقط — بيانات الأفراد (المدراء/التواصل) محذوفة قبل التخزين عمدًا.
   source: "seed"  → صف أولي بانتظار السحبة؛ يظهر بشارة "قيد التوثيق".

   explanationShort يظهر افتراضيًا في البطاقة، وexplanation الكامل يظهر
   عند ضغط "عرض التفاصيل".
   ========================================================================= */

const WATHQ_MERCHANTS = [

  /* ---------- سجلات حقيقية من واثق (بيئة الإنتاج) ---------- */
  {
    id: "addresscafe",
    displayName: "أدرس كافيه",
    displayBranch: "مقهى — الرياض",
    legalName: "شركة عنوان القهوة للتجارة",
    aliases: ["address cafe", "address cafe trd", "address cafe trd co", "address cafe co", "addresscafe", "عنوان القهوة", "ادرس كافيه"],
    crNationalNumber: "7001775498",
    crNumber: "1010307349",
    status: "نشط",
    city: "الرياض",
    entityForm: "شركة مساهمة",
    hasEcommerce: true,
    issueDateGregorian: "2011-04-20",
    activities: [
      { code: "563011", name: "محلات تقديم المشروبات (الكوفي شوب)" },
      { code: "107911", name: "تحميص البن أو طحنه أو تعبئته" },
      { code: "463053", name: "البيع بالجملة لمنتجات القهوة والشاي" }
    ],
    categoryLabel: "مقاهي",
    explanationShort: "عملية شراء من أدرس كافيه — الاسم الظاهر في كشفك هو الاسم القانوني المسجل للمقهى.",
    explanation: "هذه عملية شراء من أدرس كافيه. الاسم الظاهر في كشفك هو الاسم القانوني المسجل لدى وزارة التجارة منذ 2011، وغالبًا يختلف عن الاسم التجاري المعروف للمحل. النشاط الرئيسي المسجل: محلات تقديم المشروبات.",
    userMessage: null,
    source: "wathq"
  },
  {
    id: "nahdi",
    displayName: "صيدلية النهدي",
    displayBranch: "صيدليات — المقر الرئيسي جدة",
    legalName: "شركة النهدي الطبية",
    aliases: ["al nahdi medical co", "nahdi medical co", "al nahdi", "nahdi", "النهدي", "صيدلية النهدي", "صيدليات النهدي"],
    crNationalNumber: "7018056114",
    crNumber: "4030053868",
    status: "نشط",
    city: "جدة",
    entityForm: "شركة مساهمة",
    hasEcommerce: true,
    issueDateGregorian: "1986-06-18",
    activities: [
      { code: "477211", name: "أنشطة الصيدليات" },
      { code: "477222", name: "البيع بالتجزئة للمستلزمات الطبية" },
      { code: "477230", name: "البيع بالتجزئة لمستحضرات التجميل" }
    ],
    categoryLabel: "صيدلية",
    explanationShort: "عملية شراء من صيدليات النهدي — سجل تجاري نشط منذ 1986 ونشاطه الرئيسي الصيدليات.",
    explanation: "هذه عملية شراء من صيدليات النهدي (شركة النهدي الطبية). السجل نشط منذ عام 1986 ومقره الرئيسي في جدة، والنشاط المسجل يشمل الصيدليات والمستلزمات الطبية ومستحضرات التجميل — فقد يظهر الخصم لأدوية أو منتجات عناية.",
    userMessage: null,
    source: "wathq"
  },
  {
    id: "aldrees",
    displayName: "محطات الدريس",
    displayBranch: "محطات وقود — الرياض",
    legalName: "شركة الدريس للخدمات البترولية والنقليات",
    aliases: ["aldrees petroleum co", "aldrees petroleum", "aldrees", "al drees", "الدريس", "محطات الدريس", "محطة الدريس"],
    crNationalNumber: "7018055850",
    crNumber: "1010002475",
    status: "نشط",
    city: "الرياض",
    entityForm: "شركة مساهمة",
    hasEcommerce: false,
    issueDateGregorian: "1962-09-12",
    activities: [
      { code: "473010", name: "البيع بالتجزئة لوقود السيارات (محطات الوقود)" },
      { code: "473041", name: "تشغيل محطات شحن المركبات الكهربائية" },
      { code: "811006", name: "إدارة محطات الوقود" }
    ],
    categoryLabel: "محطة وقود",
    explanationShort: "عملية تعبئة وقود من إحدى محطات الدريس — سجل تجاري نشط منذ 1962.",
    explanation: "هذه عملية تعبئة وقود من إحدى محطات الدريس. السجل التجاري من أقدم السجلات النشطة في المملكة (منذ 1962)، وأنشطته المسجلة تشمل محطات الوقود وشحن المركبات الكهربائية — فالخصم قد يكون وقودًا أو شحنًا كهربائيًا أو خدمة مغسلة.",
    userMessage: null,
    source: "wathq"
  },
  {
    id: "hungerstation",
    displayName: "هنقرستيشن",
    displayBranch: "توصيل طعام — فرع سعودي مرخص من وزارة الاستثمار",
    legalName: "شركة فرع شركة هنجرستيشن المحدودة",
    aliases: ["hungerstation llc", "hungerstation", "هنقرستيشن", "هنجرستيشن", "هنقر ستيشن"],
    crNationalNumber: "7016019718",
    crNumber: "4030366853",
    status: "نشط",
    city: "الرياض",
    entityForm: "ذات مسؤولية محدودة — فرع",
    hasEcommerce: false,
    issueDateGregorian: "2019-10-08",
    activities: [
      { code: "532013", name: "تقديم خدمات التوصيل عبر المنصات الإلكترونية" },
      { code: "522405", name: "الوساطة الإلكترونية في نقل البضائع" },
      { code: "492311", name: "النقل الخفيف" }
    ],
    categoryLabel: "توصيل طعام",
    explanationShort: "عملية طلب طعام عبر هنقرستيشن — المبلغ يشمل الطلب ورسوم التوصيل إن وجدت.",
    explanation: "هذه عملية طلب طعام عبر تطبيق هنقرستيشن. الكيان المسجل في السعودية فرع مرخص من وزارة الاستثمار ونشاطه الرسمي التوصيل عبر المنصات الإلكترونية، والمبلغ يشمل قيمة الطلب ورسوم التوصيل إن وجدت.",
    userMessage: null,
    source: "wathq"
  },

  /* ---------- صفوف أولية بانتظار السحبة من واثق ---------- */
  {
    id: "apple",
    displayName: "آبل",
    displayBranch: "خدمات وتطبيقات إلكترونية",
    legalName: "Apple Distribution International",
    aliases: ["apple com bill", "apple.com/bill", "apple com", "itunes com", "apple services", "ابل كوم بيل", "آبل"],
    crNationalNumber: null,
    crNumber: null,
    status: null,
    city: null,
    entityForm: null,
    hasEcommerce: true,
    issueDateGregorian: null,
    activities: [{ code: "5818", name: "خدمات رقمية واشتراكات تطبيقات" }],
    categoryLabel: "خدمات وتطبيقات إلكترونية",
    explanationShort: "شراء أو تجديد اشتراك من آبل — نمط يتكرر شهريًا غالبًا.",
    explanation: "هذه عملية شراء أو تجديد اشتراك من شركة آبل (مثل زيادة مساحة التخزين أو اشتراك تطبيق). هذا النمط يتكرر شهريًا غالبًا — راقب تكراره في كشفك، ويمكنك رفع اعتراض إن لم تتعرف عليه.",
    userMessage: "وشو تاجر (آبل كوم بيل) اللي خصم مني؟",
    source: "seed"
  },
  {
    id: "thamar",
    displayName: "سوبرماركت أسواق النخبة",
    displayBranch: "فرع حي الياسمين — الرياض",
    legalName: "شركة ثمار التنمية للتجارة",
    aliases: ["thamar al-tanmiya trading co", "thamar al tanmiya", "thamar altanmiya", "ثمار التنمية للتجارة", "شركة ثمار التنمية للتجارة", "ثمار التنمية"],
    crNationalNumber: null,
    crNumber: null,
    status: null,
    city: "الرياض",
    entityForm: null,
    hasEcommerce: false,
    issueDateGregorian: null,
    activities: [{ code: "472101", name: "البيع بالتجزئة في السوبرماركت" }],
    categoryLabel: "نقاط بيع — مدى",
    explanationShort: "الاسم في كشفك هو الاسم المسجل لجهاز نقاط البيع — والجهاز يخص سوبرماركت أسواق النخبة (الياسمين).",
    explanation: "الاسم الظاهر في كشفك هو الاسم التجاري المسجل لجهاز نقاط البيع، والجهاز يخص سوبرماركت أسواق النخبة (فرع حي الياسمين). دُفع المبلغ عبر بطاقتك (مدى) بمسح الجهاز مباشرة.",
    userMessage: "مكتوب بالعملية (شركة ثمار التنمية للتجارة) ومخصوم 84 ريال، أنا ما رحت هالشركة!",
    source: "seed"
  }
];
