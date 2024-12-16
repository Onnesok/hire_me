class Banner {
  Banner({
    this.title = '',
    this.imagePath = '',
  });

  String title;
  String imagePath;

  static List<Banner> BannerList = <Banner>[
    Banner(
      imagePath: 'assets/banner/b2.png',
      title: 'banner1',
    ),
    Banner(
      imagePath: 'assets/banner/b3.png',
      title: 'banner2',
    ),
    Banner(
      imagePath: 'assets/banner/b5.png',
      title: 'banner4',
    ),
    Banner(
      imagePath: 'assets/banner/b6.png',
      title: 'banner6',
    ),
    Banner(
      imagePath: 'assets/banner/b4.png',
      title: 'banner3',
    ),
    Banner(
      imagePath: 'assets/banner/b7.png',
      title: 'banner7',
    ),
    Banner(
      imagePath: 'assets/banner/b1.png',
      title: 'banner5',
    ),
  ];
}
