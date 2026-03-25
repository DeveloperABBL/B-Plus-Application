import 'package:flutter/material.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import '../widgets/service_header.dart';
import '../widgets/service_tab_bar.dart';
import 'tabs/store_management_view.dart';
import 'tabs/service_status_view.dart';
import 'tabs/stock_inventory_view.dart';
import 'tabs/report_issue_view.dart';


class ServiceScreen extends StatefulWidget {
  final String initialTab;

  const ServiceScreen({super.key, required this.initialTab});

  static const String pagePath = '/service_page';
  static const String pageName = 'ServicePage';

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ['งานดูแลร้าน', 'ซัก อบ พับ', 'สต็อกสินค้า', 'แจ้งเรื่อง'];


  @override
  void initState() {
    super.initState();
    int initialIndex = 0;
    if (widget.initialTab == 'wash') initialIndex = 1;
    if (widget.initialTab == 'stock') initialIndex = 2;
    if (widget.initialTab == 'report') initialIndex = 3;


    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: initialIndex,
    );

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const ServiceHeader(),
            ServiceTabBar(controller: _tabController, tabs: _tabs),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  StoreManagementView(),
                  ServiceStatusView(isStoreManagement: false),
                  StockInventoryView(),
                  ReportIssueView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
