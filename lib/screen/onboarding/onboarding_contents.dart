class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "حجز المواعيد",
    image: "assets/images/imag.png",
    desc: "اسهل طريقة حجز مواعيد في السودان.",
  ),
  OnboardingContents(
    title: "سهولة حجز المواعيد",
    image: "assets/images/imag1.png",
    desc:
        "  احجز موعدك بسهولة مع اطباء متخصصين.",
  ),
  OnboardingContents(
    title: "ادارة مواعيدك",
    image: "assets/images/imag2.png",
    desc:
        "تابع واحجز مواعيدك",
  ),
];
