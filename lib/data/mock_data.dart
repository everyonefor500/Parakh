import '../models/profile.dart';
import '../models/product.dart';
import '../models/scan.dart';
import '../models/extracted_field.dart';
import '../models/compliance_verdict.dart';
import '../models/violation.dart';
import '../models/rule.dart';
import '../models/complaint.dart';
import '../models/notice.dart';
import '../models/report.dart';

class MockData {
  static final List<Profile> profiles = [
    Profile(
      id: 'prof-1',
      fullName: 'Aarav Sharma',
      email: 'aarav.sharma@gov.in',
      phone: '+919876543210',
      role: UserRole.officer,
      organization: 'Dept of Consumer Affairs',
      designation: 'Legal Metrology Officer',
      department: 'Enforcement',
      state: 'Maharashtra',
      district: 'Mumbai',
      languagePreference: 'English',
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    ),
    Profile(
      id: 'prof-2',
      fullName: 'Priya Patel',
      email: 'priya@freshfoods.in',
      phone: '+919876543211',
      role: UserRole.seller,
      organization: 'Fresh Foods Ltd',
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
    ),
    Profile(
      id: 'prof-3',
      fullName: 'Ravi Kumar',
      email: 'ravi.kumar@gmail.com',
      phone: '+919876543212',
      role: UserRole.consumer,
      createdAt: DateTime.now().subtract(const Duration(days: 50)),
    ),
    Profile(
      id: 'prof-4',
      fullName: 'Vikram Singh',
      email: 'vikram@marketplace.in',
      phone: '+919876543213',
      role: UserRole.marketplace,
      organization: 'IndiaMart',
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
    ),
  ];

  static final List<Product> products = [
    Product(
      id: 'prod-1',
      name: 'Naturals Mango Juice 1L',
      brand: 'Naturals',
      category: ProductCategory.food,
      barcode: '8901234567890',
      imageUrl: 'https://via.placeholder.com/150',
      createdBy: 'prof-2',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Product(
      id: 'prod-2',
      name: 'Glow Up Face Wash',
      brand: 'GlowUp',
      category: ProductCategory.cosmetics,
      barcode: '8901234567891',
      imageUrl: 'https://via.placeholder.com/150',
      createdBy: 'prof-2',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    Product(
      id: 'prod-3',
      name: 'TechPro Smart Watch',
      brand: 'TechPro',
      category: ProductCategory.electronics,
      barcode: '8901234567892',
      imageUrl: 'https://via.placeholder.com/150',
      createdBy: 'prof-4',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  static final List<Scan> scans = [
    Scan(
      id: 'scan-1',
      productId: 'prod-1',
      scannedBy: 'prof-1',
      imageUrl: 'https://via.placeholder.com/300',
      source: ScanSource.camera,
      ocrLanguage: 'en',
      locationLat: 19.0760,
      locationLng: 72.8777,
      locationLabel: 'Mumbai, Maharashtra',
      rawOcrText: 'Naturals Mango Juice... MRP Rs. 99...',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Scan(
      id: 'scan-2',
      productId: 'prod-2',
      scannedBy: 'prof-1',
      imageUrl: 'https://via.placeholder.com/300',
      source: ScanSource.camera,
      ocrLanguage: 'en',
      locationLat: 19.0760,
      locationLng: 72.8777,
      locationLabel: 'Mumbai, Maharashtra',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Scan(
      id: 'scan-3',
      productId: 'prod-3',
      scannedBy: 'prof-1',
      imageUrl: 'https://via.placeholder.com/300',
      source: ScanSource.upload,
      ocrLanguage: 'en',
      createdAt: DateTime.now(),
    ),
  ];

  static final List<ExtractedField> extractedFields = [
    // Fields for scan-1 (Compliant)
    ExtractedField(id: 'ef-1-1', scanId: 'scan-1', fieldName: 'MRP', fieldValue: 'Rs. 99.00', confidence: 98.5, isDetected: true, createdAt: DateTime.now()),
    ExtractedField(id: 'ef-1-2', scanId: 'scan-1', fieldName: 'Net Quantity', fieldValue: '1 Litre', confidence: 95.0, isDetected: true, createdAt: DateTime.now()),
    ExtractedField(id: 'ef-1-3', scanId: 'scan-1', fieldName: 'Manufacturer', fieldValue: 'Naturals India Pvt Ltd', confidence: 92.0, isDetected: true, createdAt: DateTime.now()),
    ExtractedField(id: 'ef-1-4', scanId: 'scan-1', fieldName: 'Address', fieldValue: 'Plot 42, MIDC Andheri, Mumbai 400093', confidence: 88.5, isDetected: true, createdAt: DateTime.now()),
    ExtractedField(id: 'ef-1-5', scanId: 'scan-1', fieldName: 'Month & Year of Packing', fieldValue: '10/2025', confidence: 99.0, isDetected: true, createdAt: DateTime.now()),
    ExtractedField(id: 'ef-1-6', scanId: 'scan-1', fieldName: 'Manufacturing Date', fieldValue: '05/10/2025', confidence: 97.5, isDetected: true, createdAt: DateTime.now()),
    ExtractedField(id: 'ef-1-7', scanId: 'scan-1', fieldName: 'Best Before/Expiry', fieldValue: '04/04/2026', confidence: 96.0, isDetected: true, createdAt: DateTime.now()),
    ExtractedField(id: 'ef-1-8', scanId: 'scan-1', fieldName: 'Country of Origin', fieldValue: 'India', confidence: 99.9, isDetected: true, createdAt: DateTime.now()),
    ExtractedField(id: 'ef-1-9', scanId: 'scan-1', fieldName: 'Consumer Care Details', fieldValue: '1800-123-4567, care@naturals.in', confidence: 91.0, isDetected: true, createdAt: DateTime.now()),
    ExtractedField(id: 'ef-1-10', scanId: 'scan-1', fieldName: 'FSSAI License Number', fieldValue: '10012022000123', confidence: 94.5, isDetected: true, createdAt: DateTime.now()),
    ExtractedField(id: 'ef-1-11', scanId: 'scan-1', fieldName: 'Unit Sale Price', fieldValue: 'Rs. 99 / L', confidence: 85.0, isDetected: true, createdAt: DateTime.now()),
    ExtractedField(id: 'ef-1-12', scanId: 'scan-1', fieldName: 'Barcode', fieldValue: '8901234567890', confidence: 99.5, isDetected: true, createdAt: DateTime.now()),

    // Fields for scan-2 (Non-Compliant)
    ExtractedField(id: 'ef-2-1', scanId: 'scan-2', fieldName: 'MRP', fieldValue: 'Rs. 250.00', confidence: 96.5, isDetected: true, createdAt: DateTime.now()),
    ExtractedField(id: 'ef-2-2', scanId: 'scan-2', fieldName: 'Net Quantity', fieldValue: '100 ml', confidence: 94.0, isDetected: true, createdAt: DateTime.now()),
    ExtractedField(id: 'ef-2-3', scanId: 'scan-2', fieldName: 'Manufacturer', fieldValue: 'GlowUp Cosmetics', confidence: 90.0, isDetected: true, createdAt: DateTime.now()),
    ExtractedField(id: 'ef-2-9', scanId: 'scan-2', fieldName: 'Consumer Care Details', fieldValue: null, confidence: 20.0, isDetected: false, createdAt: DateTime.now()),
    ExtractedField(id: 'ef-2-11', scanId: 'scan-2', fieldName: 'Unit Sale Price', fieldValue: null, confidence: 15.0, isDetected: false, createdAt: DateTime.now()),

    // Fields for scan-3 (Review)
    ExtractedField(id: 'ef-3-1', scanId: 'scan-3', fieldName: 'MRP', fieldValue: 'Rs. 1999.00', confidence: 98.5, isDetected: true, createdAt: DateTime.now()),
    ExtractedField(id: 'ef-3-7', scanId: 'scan-3', fieldName: 'Best Before/Expiry', fieldValue: '12/202X', confidence: 45.0, isDetected: true, createdAt: DateTime.now()),
  ];

  static final List<ComplianceVerdict> verdicts = [
    ComplianceVerdict(
      id: 'verdict-1',
      scanId: 'scan-1',
      status: VerdictStatus.compliant,
      complianceScore: 100.0,
      checksPassed: 12,
      checksTotal: 12,
      summary: 'All mandatory declarations are present and clearly readable.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ComplianceVerdict(
      id: 'verdict-2',
      scanId: 'scan-2',
      status: VerdictStatus.nonCompliant,
      complianceScore: 75.0,
      checksPassed: 9,
      checksTotal: 12,
      summary: 'Missing Consumer Care Details and Unit Sale Price. Violation of Rule 6.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ComplianceVerdict(
      id: 'verdict-3',
      scanId: 'scan-3',
      status: VerdictStatus.review,
      complianceScore: 90.0,
      checksPassed: 11,
      checksTotal: 12,
      summary: 'Low OCR confidence on Expiry Date. Manual review required.',
      createdAt: DateTime.now(),
    ),
  ];

  static final List<Rule> rules = [
    Rule(id: 'rule-6', ruleNumber: 'Rule 6', title: 'Declarations to be made on every package', description: 'Every package shall bear thereon or on label securely affixed thereto, a definite, plain and conspicuous declaration...', category: 'Mandatory'),
    Rule(id: 'rule-5', ruleNumber: 'Rule 5', title: 'Specific commodities', description: 'Specific declarations for certain commodities...', category: 'Specific'),
    Rule(id: 'rule-18', ruleNumber: 'Rule 18', title: 'Wholesale packages', description: 'Declarations on wholesale packages...', category: 'Wholesale'),
  ];

  static final List<Violation> violations = [
    Violation(
      id: 'viol-1',
      verdictId: 'verdict-2',
      ruleId: 'rule-6',
      fieldName: 'Consumer Care Details',
      issueTitle: 'Missing Consumer Care Information',
      description: 'The package does not contain the name, address, telephone number, and e-mail address of the person or office to be contacted in case of consumer complaints.',
      requiredValue: 'Name, Address, Phone, Email',
      severity: SeverityLevel.high,
      isIncludedInReport: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Violation(
      id: 'viol-2',
      verdictId: 'verdict-2',
      ruleId: 'rule-6',
      fieldName: 'Unit Sale Price',
      issueTitle: 'Missing Unit Sale Price',
      description: 'The package must display the unit sale price in addition to the MRP.',
      requiredValue: 'Price per ml/g/L/kg',
      severity: SeverityLevel.medium,
      isIncludedInReport: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  static final List<Complaint> complaints = [
    Complaint(
      id: 'comp-1',
      submittedBy: 'prof-3',
      productId: 'prod-1',
      scanId: 'scan-1',
      category: ComplaintCategory.mrp,
      description: 'The shopkeeper charged Rs. 110, but the MRP is Rs. 99.',
      status: ComplaintStatus.inReview,
      complaintCode: 'PRK-2026-00042',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    )
  ];

  static final List<Report> reports = [
    Report(
      id: 'rep-1',
      verdictId: 'verdict-2',
      generatedBy: 'prof-1',
      reportUrl: 'https://example.com/report1.pdf',
      status: 'Generated',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    )
  ];

  static final List<Notice> notices = [
    Notice(
      id: 'not-1',
      verdictId: 'verdict-2',
      issuedBy: 'prof-1',
      sellerName: 'Fresh Foods Ltd',
      sellerAddress: '123 Market Road, Mumbai',
      content: 'You are hereby directed to explain...',
      status: NoticeStatus.draft,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
    )
  ];

  static final Product haldiramProduct = Product(
      id: 'prod-haldiram',
      name: 'Haldiram\'s Aloo Bhujia Sev',
      brand: 'Haldiram\'s',
      category: ProductCategory.food,
      barcode: '8904004400731',
      imageUrl: 'https://via.placeholder.com/150',
      createdBy: 'prof-2',
      createdAt: DateTime.now(),
  );

  static final Scan haldiramScan = Scan(
      id: 'scan-haldiram',
      productId: 'prod-haldiram',
      scannedBy: 'prof-1',
      imageUrl: 'https://via.placeholder.com/300',
      source: ScanSource.camera,
      ocrLanguage: 'en',
      locationLat: 19.0760,
      locationLng: 72.8777,
      locationLabel: 'Mumbai, Maharashtra',
      createdAt: DateTime.now(),
  );

  static final ComplianceVerdict haldiramVerdict = ComplianceVerdict(
      id: 'verdict-haldiram',
      scanId: 'scan-haldiram',
      status: VerdictStatus.compliant,
      complianceScore: 100.0,
      checksPassed: 8,
      checksTotal: 8,
      summary: 'All 8 Legal Metrology mandatory declarations verified and approved.',
      createdAt: DateTime.now(),
  );
}
