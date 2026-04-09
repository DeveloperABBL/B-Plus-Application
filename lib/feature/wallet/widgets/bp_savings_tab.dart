import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BpSavingsTab extends StatelessWidget {
  final bool balanceVisible;
  final VoidCallback onToggleBalance;

  const BpSavingsTab({
    super.key,
    required this.balanceVisible,
    required this.onToggleBalance,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(0, AppDims.size_4, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: AppDims.size_16,
              right: AppDims.size_16,
              top: AppDims.size_4,
            ),
            child: _BalanceCard(
              balanceVisible: balanceVisible,
              onToggleBalance: onToggleBalance,
            ),
          ),
          SizedBox(height: AppDims.size_16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDims.size_8),
                  child: _InfoBanner(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDims.size_8),
                  child: _ChartCard(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDims.size_8),
                  child: _MonthlySummaryCard(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDims.size_8),
                  child: _HistoryCard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Balance card
// ─────────────────────────────────────────────
class _BalanceCard extends StatelessWidget {
  final bool balanceVisible;
  final VoidCallback onToggleBalance;

  const _BalanceCard({
    required this.balanceVisible,
    required this.onToggleBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDims.size_20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'ยอดเงินคงเหลือ',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppDims.size_6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                balanceVisible ? '฿ 1,203.54' : '฿ ••••••',
                style: AppTextStyles.displaySmall.copyWith(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: AppDims.size_8),
              GestureDetector(
                onTap: onToggleBalance,
                child: SvgPicture.asset(
                  balanceVisible ? Assets.svg.icEye : Assets.svg.icEyeSlash,
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDims.size_12),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDims.size_12,
              vertical: AppDims.size_10,
            ),
            decoration: BoxDecoration(
              color: AppColors.ci3,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.savings_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
                SizedBox(width: AppDims.size_8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ทิป',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '*กิปที่ได้รับในสัปดาห์นี้จะถูกหักภาษีก่อนลูกค้า',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '฿ 203.54',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Info banner
// ─────────────────────────────────────────────
class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppDims.size_14),
      padding: EdgeInsets.all(AppDims.size_12),
      decoration: BoxDecoration(
        color: AppColors.ci3,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.savings_outlined,
            color: AppColors.primary,
            size: 20,
          ),
          SizedBox(width: AppDims.size_8),
          Expanded(
            child: Text(
              'B+ Wallet ใช้สำหรับสะสมเงินโบนัสและกิปที่ได้รับ เงินจะถูกรวมยอดและโอนเข้าพร้อมเงินเดือน',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Savings bar chart card
// ─────────────────────────────────────────────
class _ChartCard extends StatelessWidget {
  const _ChartCard();

  static const _months = [
    'ม.ค. 69',
    'ก.พ. 69',
    'มี.ค. 69',
    'เม.ย. 69',
    'พ.ค. 69',
  ];

  static const _data = [
    [700.0, 400.0],
    [850.0, 550.0],
    [600.0, 350.0],
    [1200.0, 1500.0],
    [1003.54, 200.0],
  ];

  static const double _maxValue = 1500.0;
  static const double _barMaxHeight = 130.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDims.size_16,
        0,
        AppDims.size_16,
        AppDims.size_16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              SizedBox(width: AppDims.size_6),
              Text(
                'กราฟเงินสะสม',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDims.size_10),
          Row(
            children: [
              _LegendDot(label: 'กิป', color: AppColors.primary),
              SizedBox(width: AppDims.size_16),
              _LegendDot(label: 'โบนัส', color: AppColors.darkBlue),
            ],
          ),
          SizedBox(height: AppDims.size_16),
          SizedBox(
            height: 170,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: ['฿1,500', '฿1,000', '฿500', '฿0'].map((label) {
                    return Text(
                      label,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 9,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(width: AppDims.size_8),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(_data.length, (i) {
                            final gipH =
                                (_data[i][0] / _maxValue) * _barMaxHeight;
                            final bonusH =
                                (_data[i][1] / _maxValue) * _barMaxHeight;
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: 11,
                                  height: gipH,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(3),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Container(
                                  width: 11,
                                  height: bonusH,
                                  decoration: const BoxDecoration(
                                    color: AppColors.darkBlue,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(3),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: AppDims.size_6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _months.map((m) {
                          return Text(
                            m,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 9,
                            ),
                            textAlign: TextAlign.center,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.border),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Monthly summary card
// ─────────────────────────────────────────────
class _MonthlySummaryCard extends StatelessWidget {
  const _MonthlySummaryCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppDims.size_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'สรุปรายเดือน',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppDims.size_12),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.primary,
                size: 16,
              ),
              SizedBox(width: AppDims.size_6),
              Text(
                'พ.ค. 69',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDims.size_10),
          const _SummaryRow(
            label: 'กิป',
            value: '+ 1,003.54',
            valueColor: AppColors.primary,
          ),
          SizedBox(height: AppDims.size_6),
          const _SummaryRow(
            label: 'โบนัส',
            value: '+ 203.00',
            valueColor: AppColors.darkBlue,
          ),
          Divider(height: AppDims.size_20, color: AppColors.border),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'รวม',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '+ 1,203.54',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDims.size_12),
          Center(
            child: Column(
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'แสดงข้อมูล',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Transaction history card
// ─────────────────────────────────────────────
enum _TxFilter { all, tip, bonus, withdraw }

class _HistoryCard extends StatefulWidget {
  const _HistoryCard();

  @override
  State<_HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<_HistoryCard> {
  _TxFilter _filter = _TxFilter.all;

  static const _transactions = [
    _TxItem(
      type: _TxFilter.withdraw,
      title: 'ถอนเงิน',
      subtitle: 'รอบระยะเวลา\n15 ธ.ค. 2025 - 15 ม.ค. 2026',
      amount: '- 2,000.00',
      date: '30 พ.ค. 2025 - 16:44:00 น.',
      isNegative: true,
    ),
    _TxItem(
      type: _TxFilter.bonus,
      title: 'โบนัส',
      subtitle: 'แคมเปญ xxxxxxxxxxxxx',
      amount: '+ 80.00',
      date: '30 พ.ค. 2025 - 16:44:00 น.',
      isNegative: false,
    ),
    _TxItem(
      type: _TxFilter.tip,
      title: 'กิป',
      subtitle: 'จาก จอน ส.',
      amount: '+ 20.00',
      date: '30 พ.ค. 2025 - 16:44:00 น.',
      isNegative: false,
    ),
    _TxItem(
      type: _TxFilter.tip,
      title: 'กิป',
      subtitle: 'จาก จอน ส.',
      amount: '+ 20.00',
      date: '30 พ.ค. 2025 - 16:44:00 น.',
      isNegative: false,
    ),
    _TxItem(
      type: _TxFilter.bonus,
      title: 'โบนัส',
      subtitle: 'แคมเปญ xxxxxxxxxxxxx',
      amount: '+ 80.00',
      date: '30 พ.ค. 2025 - 16:44:00 น.',
      isNegative: false,
    ),
  ];

  List<_TxItem> get _filtered => _filter == _TxFilter.all
      ? _transactions
      : _transactions.where((t) => t.type == _filter).toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppDims.size_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.ci3,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.access_time_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              SizedBox(width: AppDims.size_8),
              Expanded(
                child: Text(
                  'ประวัติรายการ',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'ดูทั้งหมด',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDims.size_12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'ทั้งหมด',
                  active: _filter == _TxFilter.all,
                  onTap: () => setState(() => _filter = _TxFilter.all),
                ),
                SizedBox(width: AppDims.size_8),
                _FilterChip(
                  label: 'กิป',
                  active: _filter == _TxFilter.tip,
                  onTap: () => setState(() => _filter = _TxFilter.tip),
                ),
                SizedBox(width: AppDims.size_8),
                _FilterChip(
                  label: 'โบนัส',
                  active: _filter == _TxFilter.bonus,
                  onTap: () => setState(() => _filter = _TxFilter.bonus),
                ),
                SizedBox(width: AppDims.size_8),
                _FilterChip(
                  label: 'ถอนเงิน',
                  active: _filter == _TxFilter.withdraw,
                  onTap: () => setState(() => _filter = _TxFilter.withdraw),
                ),
              ],
            ),
          ),
          SizedBox(height: AppDims.size_8),
          ..._filtered.map((tx) => _TxRow(item: tx)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Filter chip
// ─────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDims.size_16,
          vertical: AppDims.size_8,
        ),
        decoration: BoxDecoration(
          color: active ? Colors.transparent : Colors.transparent,
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
            width: active ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: active ? AppColors.primary : AppColors.textSecondary,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Transaction data model
// ─────────────────────────────────────────────
class _TxItem {
  final _TxFilter type;
  final String title;
  final String subtitle;
  final String amount;
  final String date;
  final bool isNegative;

  const _TxItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.isNegative,
  });
}

// ─────────────────────────────────────────────
// Transaction row
// ─────────────────────────────────────────────
class _TxRow extends StatelessWidget {
  final _TxItem item;

  const _TxRow({required this.item});

  IconData get _icon {
    return switch (item.type) {
      _TxFilter.withdraw => Icons.upload_rounded,
      _TxFilter.bonus => Icons.volunteer_activism_outlined,
      _TxFilter.tip => Icons.handshake_outlined,
      _TxFilter.all => Icons.receipt_long_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: AppDims.size_16, color: AppColors.border),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.grayBg,
                shape: BoxShape.circle,
              ),
              child: Icon(_icon, color: AppColors.gray500, size: 20),
            ),
            SizedBox(width: AppDims.size_12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppDims.size_2),
                  Text(
                    item.subtitle,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppDims.size_8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.amount,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: item.isNegative
                        ? AppColors.error
                        : AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppDims.size_2),
                Text(
                  item.date,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Legend dot
// ─────────────────────────────────────────────
class _LegendDot extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendDot({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: AppDims.size_4),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Summary row
// ─────────────────────────────────────────────
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.labelMedium.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
