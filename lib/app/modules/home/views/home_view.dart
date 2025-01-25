import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teck_app/app/modules/products/views/product_view.dart';
import 'package:teck_app/theme/colors.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Center(
      child: Text(
        'Inicio',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
    ProductView(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onPrincipalBackground,
      body: Column(
        children: [
          CustomAppBar(userName: ""),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final String userName;

  const CustomAppBar({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top; 

    return Container(
      padding: EdgeInsets.only(
        top: statusBarHeight,
        left: 16.0,
        right: 16.0,
      ),
      height: MediaQuery.of(context).size.height * 0.1 + statusBarHeight,
      color: AppColors.onPrincipalBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Bienvenido,",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.onPrincipalBackground,
      selectedItemColor: AppColors.principalGreen,
      unselectedItemColor: AppColors.menuSideBar,
      currentIndex: currentIndex,
      onTap: onTabSelected,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Inicio",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: "Productos",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sell),
          label: "Ventas",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_vert_sharp),
          label: "Más",
        ),
      ],
    );
  }
}

