import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:brownyplus/core/widgets/top_back_button.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  static const String pagePath = '/scanner';
  static const String pageName = 'ScannerPage';

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late final MobileScannerController _controller;
  final ImagePicker _imagePicker = ImagePicker();

  bool _checkingPermission = true;
  bool _cameraGranted = false;
  PermissionStatus _cameraStatus = PermissionStatus.denied;
  bool _handled = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      formats: const [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.normal,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _requestCamera());
  }

  Future<void> _requestCamera() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }
    if (!mounted) return;
    setState(() {
      _checkingPermission = false;
      _cameraStatus = status;
      _cameraGranted = status.isGranted;
    });
  }

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  void _onValidQr(String code) {
    if (_handled) return;
    _handled = true;
    debugPrint('[ScannerScreen] สแกน QR สำเร็จ — ข้อมูล: $code');
    unawaited(_controller.stop());
    if (mounted) {
      context.pop<String>(code);
    }
  }

  void _onDetect(BarcodeCapture capture) {
    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code == null || code.isEmpty) return;
    _onValidQr(code);
  }

  Future<void> _scanFromGallery() async {
    final file = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (file == null || !mounted) return;

    try {
      final capture = await _controller.analyzeImage(
        file.path,
        formats: const [BarcodeFormat.qrCode],
      );
      final raw = capture?.barcodes.firstOrNull?.rawValue;
      if (raw == null || raw.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'ไม่พบ QR Code ในภาพ',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }
      _onValidQr(raw);
    } on UnsupportedError {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'สแกนจากรูปภาพยังไม่รองรับบน iOS Simulator',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'ไม่สามารถอ่าน QR จากภาพได้',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _onPermissionPrimaryPressed() async {
    if (_cameraStatus.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      await _requestCamera();
    }
  }

  Future<void> _toggleTorch() async {
    await _controller.toggleTorch();
    if (mounted) setState(() {});
  }

  Widget _buildPermissionGate() {
    final primaryLabel = _cameraStatus.isPermanentlyDenied
        ? 'เปิดการตั้งค่า'
        : 'อนุญาตใช้กล้อง';

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1B1B1B),
            Color(0xFF090909),
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              _buildTopBar(),
              SizedBox(height: 32.h),
              Icon(
                Icons.camera_alt_outlined,
                size: 64.sp,
                color: Colors.white.withValues(alpha: 0.85),
              ),
              SizedBox(height: 20.h),
              Text(
                'ต้องการสิทธิ์ใช้กล้อง',
                textAlign: TextAlign.center,
                style: AppTextStyles.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'แอปใช้กล้องเพื่อสแกน QR Code เท่านั้น',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 28.h),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _onPermissionPrimaryPressed,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.ctaPrimaryDefault,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: Text(
                    primaryLabel,
                    style: AppTextStyles.titleSmall.copyWith(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: _scanFromGallery,
                child: Text(
                  'เลือกรูป QR จากคลังภาพ',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanOverlay() {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.5),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
              Center(
                child: Container(
                  width: 260.w,
                  height: 260.w,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            width: 260.w,
            height: 260.w,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        Positioned(
          top: 0.5.sh + 160.h,
          left: 30.w,
          right: 30.w,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              'กรุณาสแกนที่ QR Code ให้อยู่ในกรอบ\nหรือกดไอคอนรูปภาพเพื่อเลือกจากคลัง',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScannerBody() {
    return Stack(
      fit: StackFit.expand,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final side = 260.w;
            final rect = Rect.fromCenter(
              center: Offset(constraints.maxWidth / 2, constraints.maxHeight / 2),
              width: side,
              height: side,
            );
            return MobileScanner(
              controller: _controller,
              fit: BoxFit.cover,
              scanWindow: rect,
              onDetect: _onDetect,
              errorBuilder: (context, error) {
                return ColoredBox(
                  color: Colors.black,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.videocam_off_outlined,
                            color: Colors.white70,
                            size: 48.sp,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            error.errorDetails?.message ?? 'ไม่สามารถเปิดกล้องได้',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          FilledButton(
                            onPressed: _scanFromGallery,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.ctaPrimaryDefault,
                            ),
                            child: Text(
                              'เลือกรูป QR จากคลังภาพ',
                              style: AppTextStyles.titleSmall.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        _buildScanOverlay(),
        _buildTopBar(),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ScannerCircleButton(
                    icon: Icons.image_outlined,
                    onPressed: _scanFromGallery,
                  ),
                  ValueListenableBuilder<MobileScannerState>(
                    valueListenable: _controller,
                    builder: (context, state, _) {
                      final on = state.torchState == TorchState.on;
                      return _ScannerCircleButton(
                        icon: on ? Icons.flash_on : Icons.flash_off,
                        onPressed: state.torchState == TorchState.unavailable
                            ? null
                            : _toggleTorch,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return SizedBox(
      height: 56.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'การสแกน',
                style: AppTextStyles.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8.w),
              SvgPicture.asset(
                Assets.svg.icScan,
                width: 20.w,
                height: 20.w,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ],
          ),
          const TopBackButton(color: Colors.white),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _checkingPermission
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : _cameraGranted
              ? _buildScannerBody()
              : _buildPermissionGate(),
    );
  }
}

class _ScannerCircleButton extends StatelessWidget {
  const _ScannerCircleButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.15),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 56.w,
          height: 56.w,
          child: Icon(
            icon,
            color: onPressed == null ? Colors.white38 : Colors.white,
            size: 26.sp,
          ),
        ),
      ),
    );
  }
}
