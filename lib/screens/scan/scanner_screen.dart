import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../providers/scan_flow_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanLineController;
  late Animation<double> _scanLine;
  late Animation<double> _cornerGlow;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _cameraPermissionDenied = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _scanLine = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanLineController, curve: Curves.easeInOut),
    );
    _cornerGlow = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _scanLineController, curve: Curves.easeInOut),
    );
    _initCamera();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (status.isPermanentlyDenied || status.isDenied) {
      if (mounted) {
        setState(() {
          _cameraPermissionDenied = true;
        });
      }
      return;
    }

    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    try {
      final XFile image = await _cameraController!.takePicture();
      if (mounted) {
        context.read<ScanFlowProvider>().startScan(image.path);
        context.pushReplacement(AppRoutes.scanProcessing);
      }
    } catch (e) {
      debugPrint('Error capturing image: $e');
    }
  }

  Future<void> _pickGalleryImage() async {
    // Check storage/photos permission
    final status = await Permission.photos.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      final storageStatus = await Permission.storage.request();
      if (storageStatus.isDenied || storageStatus.isPermanentlyDenied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Storage permission is required for gallery access.'),
              action: SnackBarAction(
                label: 'Settings',
                onPressed: () => openAppSettings(),
              ),
            ),
          );
        }
        return;
      }
    }

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null && mounted) {
        context.read<ScanFlowProvider>().startScan(image.path);
        context.pushReplacement(AppRoutes.scanProcessing);
      }
    } catch (e) {
      debugPrint('Error picking gallery image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050A12),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 20),
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.photo_library_outlined, color: Colors.white, size: 20),
            ),
            onPressed: _pickGalleryImage,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _cameraPermissionDenied
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.statusViolationRed.withValues(alpha: 0.1),
                        border: Border.all(
                          color: AppColors.statusViolationRed.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.no_photography_outlined,
                        color: AppColors.statusViolationRed,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Camera Access Denied',
                      style: AppTextStyles.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Parakh needs camera access to scan product labels. Please enable it in your device settings.',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => openAppSettings(),
                      child: const Text('Open Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                // Camera Preview
                if (_isCameraInitialized && _cameraController != null)
                  SizedBox.expand(
                    child: CameraPreview(_cameraController!),
                  )
                else
                  // Mock background if camera fails
                  Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF0A1020),
                          const Color(0xFF050810),
                        ],
                        radius: 1.2,
                      ),
                    ),
                  ),

                // Camera mock label if not initialized
                if (!_isCameraInitialized)
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 40),
                        Icon(Icons.camera_alt_outlined,
                            color: Colors.white12, size: 48),
                        SizedBox(height: 12),
                        Text(
                          'Initializing camera...',
                          style: TextStyle(
                              color: Colors.white24,
                              fontSize: 14,
                              letterSpacing: 0.3),
                        ),
                      ],
                    ),
                  ),

                // Vignette overlays
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 140,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 220,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.9),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Scanner overlay with corner markers + scan line
                Center(
                  child: SizedBox(
                    width: 288,
                    height: 380,
                    child: Stack(
                      children: [
                        // Corner markers
                        AnimatedBuilder(
                          animation: _cornerGlow,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _cornerGlow.value,
                              child: Stack(
                                children: _buildCornerMarkers(),
                              ),
                            );
                          },
                        ),

                        // Animated scan line
                        AnimatedBuilder(
                          animation: _scanLine,
                          builder: (context, child) {
                            return Positioned(
                              top: 2 + (_scanLine.value * 372),
                              left: 12,
                              right: 12,
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.accentBlue.withValues(alpha: 0),
                                      AppColors.accentBlueGlow,
                                      AppColors.accentBlue.withValues(alpha: 0),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accentBlue
                                          .withValues(alpha: 0.6),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom instruction + capture button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 56.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Point camera at product label',
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Capture button
                        GestureDetector(
                          key: const Key('capture_button'),
                          onTapDown: (_) => setState(() => _isPressed = true),
                          onTapUp: (_) {
                            setState(() => _isPressed = false);
                            _captureImage();
                          },
                          onTapCancel: () => setState(() => _isPressed = false),
                          child: AnimatedScale(
                            scale: _isPressed ? 0.9 : 1.0,
                            duration: const Duration(milliseconds: 100),
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accentBlue.withValues(alpha: 0.5),
                                    blurRadius: 32,
                                    spreadRadius: 8,
                                  ),
                                  BoxShadow(
                                    color: AppColors.accentBlue.withValues(alpha: 0.2),
                                    blurRadius: 48,
                                    spreadRadius: 16,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  width: 62,
                                  height: 62,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: AppColors.scanButtonGradient,
                                  ),
                                  child: const Icon(Icons.camera_alt,
                                      color: Colors.white, size: 26),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  List<Widget> _buildCornerMarkers() {
    const markerLength = 24.0;
    const markerThickness = 3.0;
    const markerColor = AppColors.accentBlueGlow;
    const radius = Radius.circular(4);

    return [
      // Top-left
      Positioned(
        top: 0,
        left: 0,
        child: _corner(markerLength, markerThickness, markerColor, radius,
            top: true, left: true),
      ),
      // Top-right
      Positioned(
        top: 0,
        right: 0,
        child: _corner(markerLength, markerThickness, markerColor, radius,
            top: true, left: false),
      ),
      // Bottom-left
      Positioned(
        bottom: 0,
        left: 0,
        child: _corner(markerLength, markerThickness, markerColor, radius,
            top: false, left: true),
      ),
      // Bottom-right
      Positioned(
        bottom: 0,
        right: 0,
        child: _corner(markerLength, markerThickness, markerColor, radius,
            top: false, left: false),
      ),
    ];
  }

  Widget _corner(double length, double thickness, Color color, Radius radius,
      {required bool top, required bool left}) {
    return SizedBox(
      width: length,
      height: length,
      child: CustomPaint(
        painter: _CornerPainter(
            color: color,
            thickness: thickness,
            top: top,
            isLeft: left,
            radius: 6),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool top;
  final bool isLeft;
  final double radius;

  _CornerPainter({
    required this.color,
    required this.thickness,
    required this.top,
    required this.isLeft,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    if (top && isLeft) {
      canvas.drawLine(Offset(0, h), Offset(0, radius), paint);
      canvas.drawLine(Offset(radius, 0), Offset(w, 0), paint);
      canvas.drawArc(Rect.fromLTWH(0, 0, radius * 2, radius * 2),
          3.14159, -1.5708, false, paint);
    } else if (top && !isLeft) {
      canvas.drawLine(Offset(w, h), Offset(w, radius), paint);
      canvas.drawLine(Offset(w - radius, 0), Offset(0, 0), paint);
      canvas.drawArc(Rect.fromLTWH(w - radius * 2, 0, radius * 2, radius * 2),
          0, -1.5708, false, paint);
    } else if (!top && isLeft) {
      canvas.drawLine(Offset(0, 0), Offset(0, h - radius), paint);
      canvas.drawLine(Offset(radius, h), Offset(w, h), paint);
      canvas.drawArc(
          Rect.fromLTWH(0, h - radius * 2, radius * 2, radius * 2),
          1.5708,
          1.5708,
          false,
          paint);
    } else {
      canvas.drawLine(Offset(w, 0), Offset(w, h - radius), paint);
      canvas.drawLine(Offset(w - radius, h), Offset(0, h), paint);
      canvas.drawArc(
          Rect.fromLTWH(w - radius * 2, h - radius * 2, radius * 2, radius * 2),
          0,
          1.5708,
          false,
          paint);
    }
  }

  @override
  bool shouldRepaint(_CornerPainter oldDelegate) => false;
}
