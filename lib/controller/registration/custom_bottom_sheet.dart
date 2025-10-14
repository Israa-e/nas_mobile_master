import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/controller/registration/page_ten_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/view/widget/custom_title.dart';
import 'package:nas/view/widget/primary_button.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final String documentType;
  final int termIndex;

  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.documentType,
    required this.termIndex,
  });

  @override
  Widget build(BuildContext context) {
    String documentContent = getDocumentContent(documentType);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      padding: const EdgeInsets.all(30),

      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTitle(
            title: title,
            isIcon: false,
            color: AppTheme.primaryColor,
          ),
          SizedBox(height: 26),

          // Document content
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
              decoration: BoxDecoration(
                color: Color(0xffEEEEEE),

                borderRadius: BorderRadius.circular(30),
              ),
              child: SingleChildScrollView(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    documentContent,
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: AppTheme.secondaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 26),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 45),
            child: PrimaryButton(
              onTap: () {
                final controller = Get.find<PageTenController>();
                controller.selectedTerms[termIndex] = true;
                controller.selectedTerms.refresh(); // لإعلام الـ UI
                Get.back(); // إغلاق الـ BottomSheet
              },
              text: "موافقة",
              color: AppTheme.primaryColor,
              textColor: AppTheme.white,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get the document content based on type
  String getDocumentContent(String documentType) {
    switch (documentType) {
      case 'أوافق على شروط وقواعد العمل':
        return '''
سياسة: الالتزام بقواعد العمل ضروري لضمان بيئة عمل منظمة وآمنة  
قاعدة العمل: يجب على جميع الموظفين الالتزام بساعات العمل المحددة، والحفاظ على سرية معلومات الشركة، وارتداء الزي الرسمي المحدد حسب السياسة.  
يحظر استخدام موارد الشركة لأغراض شخصية، ويجب الالتزام بإجراءات السلامة المهنية في جميع الأوقات.  
يجب حضور الاجتماعات في الوقت المحدد، وإبلاغ المشرف في حال الغياب أو التأخير، واتباع التسلسل الإداري في التواصل الرسمي.  
يمنع أي شكل من أشكال التمييز أو التحرش، ويجب الحفاظ على بيئة عمل نظيفة ومرتبة.  
الالتزام بهذه القواعد مسؤولية كل موظف، وقد يؤدي انتهاكها إلى إجراءات تأديبية.

      ''';

      case 'أوافق على قواعد السلوك المهني والأخلاقي':
        return '''
سياسة: نلتزم بأعلى المعايير الأخلاقية والمهنية في أداء أعمالنا  
قاعدة العمل: يجب التصرف بنزاهة وأمانة في جميع التعاملات، واحترام الجميع دون تمييز.  
تجنب تضارب المصالح أمر أساسي، ويجب الإعلان عن أي تضارب محتمل.  
يجب الالتزام بالمعايير المهنية وعدم مشاركة المعلومات السرية مع أطراف غير مخولة.  
ينبغي تقديم الخدمات بأعلى جودة، والامتثال لجميع القوانين والأنظمة.  
يُمنع الرشوة أو الفساد بأي شكل، ويجب الإبلاغ عن أي مخالفات دون خوف.  
يجب المساهمة في تعزيز بيئة عمل إيجابية وصحية.

تتوقع الشركة من جميع موظفيها الالتزام بهذه القواعد التي تمثل أساس الثقة والمسؤولية.

      ''';

      case 'أوافق على شروط وسياسات الخصوصية':
        return '''
سياسة: نلتزم بحماية خصوصية بيانات الأفراد والتعامل معها بمسؤولية  
قاعدة العمل: يتم جمع البيانات الشخصية فقط عند الحاجة، ولا تتم مشاركتها مع أي طرف دون موافقة صريحة.  
تطبق الشركة إجراءات أمنية مشددة لمنع الوصول غير المصرح به.  
للأفراد الحق في الاطلاع على بياناتهم وتصحيحها أو حذفها.  
تُحتفظ البيانات للفترة اللازمة فقط، وتخضع السياسة لمراجعة دورية.  
يلتزم الموظفون بالتعامل مع البيانات الشخصية بسرية وأمان، وتتم معاقبة أي خرق أمني جسيم.  
تلتزم الشركة بجميع قوانين وتشريعات حماية البيانات.

بقبولك لهذه السياسة، فإنك توافق على جمع واستخدام بياناتك بالشكل الموضح.

      ''';

      case 'أوافق على شروط الاستخدام':
        return '''
سياسة: استخدام موارد وأنظمة الشركة يجب أن يتم بطريقة مسؤولة وآمنة  
قاعدة العمل: يجب استخدام الأنظمة فقط لأغراض العمل الرسمية، ويحظر تنزيل برامج غير مصرح بها.  
يتحمل كل مستخدم مسؤولية الحفاظ على سرية بيانات الدخول، ويجب الإبلاغ عن أي نشاط غير طبيعي أو خرق أمني.  
لدى الشركة الحق في مراقبة الاستخدام لضمان الأمن.  
يُمنع استخدام الموارد لأغراض غير قانونية أو غير أخلاقية، أو مشاركة الحسابات مع الآخرين.  
يجب احترام حقوق الملكية الفكرية، والالتزام بجميع سياسات أمن المعلومات.  
تحتفظ الشركة بالحق في تعديل هذه الشروط في أي وقت.

عدم الالتزام بهذه الشروط قد يؤدي إلى اتخاذ إجراءات تأديبية أو قانونية.

      ''';

      case 'سياسات وقواعد العمل التشغيلية':
        return '''
سياسة: السلامة هي محور اهتمامنا الأول  
قاعدة العمل: يجب على الأفراد ارتداء خوذة عند تواجدهم في موقع البناء.  
يجب على المفتشين القيام بدورات تفتيشية أسبوعية على مواقع البناء والتأكد من استيفاء اشتراطات السلامة.  
إذا تعطلت آلة تكسير الخرسانة في الموقع، فيجب تبديلها خلال 4 ساعات من العطل.

سياسة: نحرص على أن نقوم بأعمال الصيانة بطريقة تزيد من عمر الأجهزة وفعاليتها  
قاعدة العمل: إذا مر عام على تسليم الأجهزة لفريق العمل، فيجب على فني الصيانة مراجعة الأجهزة والتأكد من أن لا تقل سرعتها عن 80٪ من سرعتها الأصلية.

سياسة: نلتزم بتوفير بيئة عمل تساعد على اتخاذ قرارات سريعة ومبنية على معطيات  
قاعدة العمل: يجب على مسؤولي الفريق تقديم تقارير الأداء أسبوعيًا باستخدام النموذج المعتمد، على أن يتم مراجعة التقرير خلال 24 ساعة من تسليمه.

سياسة: الجودة مسؤولية الجميع  
قاعدة العمل: لا يتم تسليم أي منتج إلا بعد مراجعته من قبل مشرف الجودة باستخدام قائمة التحقق المعتمدة، ويتم توثيق نتيجة الفحص إلكترونيًا.

كما نرى، قواعد العمل مكتوبة على مستوى تشغيلي محدد، يمكن قياسه واختباره.  
لماذا نضيع الوقت في كتابة سياسات تبدو عامة وتحتاج دائماً إلى تفسير؟ لماذا لا نكتب قواعد العمل مباشرة؟  
السياسات المكتوبة بشكل جيد تحرر وقت القيادات من الانشغال بالمواقف التشغيلية التي يمكن أن يعالجها الموظفون بشيء من الحرية والسرعة التي يتطلبها الموقف دون إشراك القيادات.  
السياسات المكتوبة بشكل جيد توضح حدود الموظفين في اتخاذ القرار وتمنحهم قدرًا جيدًا من الحرية لتغيير قواعد عملهم بما يتناسب مع الاحتياجات المتغيرة للعمليات التشغيلية.
      ''';

      default:
        return documentType;
    }
  }
}
