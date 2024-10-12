class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent({required this.image, required this.title, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
    title: 'Quality Laptops',
    image: 'images/logo2.jpg', // استبدال الصورة
    discription: "Discover a wide range of high-quality laptops from top brands. Whether you're a professional or a student, find the perfect laptop that suits your needs with exceptional performance and style.",
  ),
  UnbordingContent(
    title: 'Fast Delivery',
    image: 'images/logo2.jpg', // استبدال الصورة
    discription: "Enjoy fast and reliable delivery of your favorite laptops and computers. We ensure that your order reaches you quickly and safely, so you can start using your new device without delay.",
  ),
  UnbordingContent(
    title: 'Exclusive Deals',
    image: 'images/logo2.jpg', // استبدال الصورة
    discription: "Get access to exclusive deals and discounts on the latest laptops and computer accessories. Save more with our special offers and promotions, and make the most out of your purchase.",
  ),
];
