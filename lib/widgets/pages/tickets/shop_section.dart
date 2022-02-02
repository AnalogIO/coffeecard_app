part of 'tickets_page.dart';

class ShopSection extends StatelessWidget {
  const ShopSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(Strings.shopText, style: AppTextStyle.sectionTitle),
          ),
          GridView.count(
            childAspectRatio: 3 / 2,
            primary: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            crossAxisCount: 2,
            children: [
              ShopCard(
                title: Strings.buyTickets,
                icon: Icons.style,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BuyTicketsPage(),
                    ),
                  );
                },
              ),
              ShopCard(
                title: Strings.buyOneDrink,
                icon: Icons.coffee,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BuyOneDrinkPage(),
                    ),
                  );
                },
              ),
              ShopCard(
                title: Strings.buyOther,
                icon: Icons.coffee,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BuyOtherPage(),
                    ),
                  );
                },
              ),
              ShopCard(
                title: Strings.redeemVoucher,
                icon: Icons.wallet_giftcard,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RedeemVoucherPage(),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ShopCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onPressed;

  const ShopCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Tappable(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColor.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  icon,
                  color: AppColor.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
