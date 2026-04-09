import 'package:brownyplus/feature/wallet/widgets/bp_savings_tab.dart';
import 'package:brownyplus/feature/wallet/widgets/tp_wallet_tab.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  static const pagePath = '/wallet_page';
  static const pageName = 'WalletPage';

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _tpBalanceVisible = true;
  bool _bpBalanceVisible = true;
  final TextEditingController _amountController = TextEditingController();

  static const Color _tpBg = AppColors.darkBlue;
  static const Color _bpBg = Color(0xFF2FBA38);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  bool get _isFirstTab => _tabController.index == 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isFirstTab ? _tpBg : _bpBg,
      body: Column(
        children: [
          SafeArea(bottom: false, child: _buildAppBar()),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDims.size_40,
              vertical: AppDims.size_10,
            ),
            child: _buildTabSelector(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                TpWalletTab(
                  balanceVisible: _tpBalanceVisible,
                  onToggleBalance: () =>
                      setState(() => _tpBalanceVisible = !_tpBalanceVisible),
                  amountController: _amountController,
                ),
                BpSavingsTab(
                  balanceVisible: _bpBalanceVisible,
                  onToggleBalance: () =>
                      setState(() => _bpBalanceVisible = !_bpBalanceVisible),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDims.size_16,
        AppDims.size_12,
        AppDims.size_16,
        AppDims.size_4,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: SvgPicture.asset(
              Assets.svg.icBack,
              width: AppDims.size_24,
              height: AppDims.size_24,
              colorFilter: const ColorFilter.mode(
                AppColors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          Expanded(
            child: Text(
              _isFirstTab ? 'TP+ Wallet' : 'กระเป๋าเงิน B+',
              textAlign: TextAlign.center,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            width: AppDims.size_32,
            height: AppDims.size_32,
            child: SvgPicture.asset(
              Assets.svg.icHeadsetHelp,
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                AppColors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _tabController.animateTo(0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: AppDims.size_10),
                decoration: BoxDecoration(
                  color: _isFirstTab
                      ? AppColors.cocoaBrown
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.svg.icTpWallet,
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'TP+ Wallet',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: _isFirstTab
                            ? AppColors.white
                            : AppColors.textPrimary,
                        fontWeight: _isFirstTab
                            ? FontWeight.w600
                            : FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _tabController.animateTo(1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: AppDims.size_10),
                decoration: BoxDecoration(
                  color: _isFirstTab
                      ? Colors.transparent
                      : AppColors.ctaPrimaryDefault,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SvgPicture.asset(
                    //   Assets.svg.icCalendar,
                    //   width: 15,
                    //   height: 15,
                    //   colorFilter: const ColorFilter.mode(
                    //     AppColors.white,
                    //     BlendMode.srcIn,
                    //   ),
                    // ),
                    // const SizedBox(width: 6),
                    Text(
                      'B+ เงินออมสะสม',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: _isFirstTab
                            ? AppColors.textPrimary
                            : AppColors.white,
                        fontWeight: _isFirstTab
                            ? FontWeight.w400
                            : FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
