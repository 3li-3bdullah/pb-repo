import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Issues Register',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'SF Pro Display',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      home: const FarmingHomeScreen(),
    );
  }
}

// 1. Models
class IssueModel {
  final String id;
  final DateTime datetime;
  final String type;
  final String subtype;
  final String item;
  final String farmerId;
  final String fieldId;
  final String issueInput;
  final String? issueResponse;
  final double? sdgAmount;
  final String status;
  final DateTime statusTime;

  IssueModel({
    required this.id,
    required this.datetime,
    required this.type,
    required this.subtype,
    required this.item,
    required this.farmerId,
    required this.fieldId,
    required this.issueInput,
    this.issueResponse,
    this.sdgAmount,
    required this.status,
    required this.statusTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'datetime': datetime.toIso8601String(),
      'type': type,
      'subtype': subtype,
      'item': item,
      'farmerId': farmerId,
      'fieldId': fieldId,
      'issueInput': issueInput,
      'issueResponse': issueResponse,
      'sdgAmount': sdgAmount,
      'status': status,
      'statusTime': statusTime.toIso8601String(),
    };
  }

  static IssueModel fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['id'],
      datetime: DateTime.parse(json['datetime']),
      type: json['type'],
      subtype: json['subtype'],
      item: json['item'],
      farmerId: json['farmerId'],
      fieldId: json['fieldId'],
      issueInput: json['issueInput'],
      issueResponse: json['issueResponse'],
      sdgAmount: json['sdgAmount']?.toDouble(),
      status: json['status'],
      statusTime: DateTime.parse(json['statusTime']),
    );
  }

  IssueModel copyWith({
    String? id,
    DateTime? datetime,
    String? type,
    String? subtype,
    String? item,
    String? farmerId,
    String? fieldId,
    String? issueInput,
    String? issueResponse,
    double? sdgAmount,
    String? status,
    DateTime? statusTime,
  }) {
    return IssueModel(
      id: id ?? this.id,
      datetime: datetime ?? this.datetime,
      type: type ?? this.type,
      subtype: subtype ?? this.subtype,
      item: item ?? this.item,
      farmerId: farmerId ?? this.farmerId,
      fieldId: fieldId ?? this.fieldId,
      issueInput: issueInput ?? this.issueInput,
      issueResponse: issueResponse ?? this.issueResponse,
      sdgAmount: sdgAmount ?? this.sdgAmount,
      status: status ?? this.status,
      statusTime: statusTime ?? this.statusTime,
    );
  }
}

// 2. Color constants
class AppColors {
  static const Color primary = Color(0xff83C541);
  static const Color secondary = Color.fromARGB(255, 189, 233, 144);
  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);
  static const Color grey = Color(0xff9E9E9E);
  static const Color lightGrey = Color(0xffF5F5F5);
  static const Color urgentRed = Color(0xffE53E3E);
  static const Color warningOrange = Color(0xffD69E2E);
  static const Color infoBlue = Color(0xff3182CE);
  static const Color successGreen = Color(0xff38A169);
  static const Color cardBorder = Color(0xffE2E8F0);
  static const Color textSecondary = Color(0xff64748B);
  static const Color background = Color(0xffF8FAFC);
}

// 3. Main Home Screen
class FarmingHomeScreen extends StatefulWidget {
  const FarmingHomeScreen({super.key});

  @override
  State<FarmingHomeScreen> createState() => _FarmingHomeScreenState();
}

class _FarmingHomeScreenState extends State<FarmingHomeScreen> with TickerProviderStateMixin {
  List<IssueModel> issues = [];
  String searchQuery = '';
  String selectedFilter = 'All';
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _loadSampleIssues();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _loadSampleIssues() {
    issues = [
      IssueModel(
        id: '1',
        datetime: DateTime.now().subtract(const Duration(days: 1)),
        type: 'Issue',
        subtype: 'Irrigation',
        item: 'Field',
        farmerId: 'F001',
        fieldId: 'FIELD001',
        issueInput: 'Increase irrigation in north-east sector',
        issueResponse: null,
        sdgAmount: null,
        status: 'Urgent',
        statusTime: DateTime.now(),
      ),
      IssueModel(
        id: '2',
        datetime: DateTime.now().subtract(const Duration(days: 2)),
        type: 'Alert',
        subtype: 'Fertilization',
        item: 'Field',
        farmerId: 'F001',
        fieldId: 'FIELD001',
        issueInput: 'Apply nitrogen fertilizer',
        issueResponse: null,
        sdgAmount: 500.0,
        status: 'Urgent',
        statusTime: DateTime.now(),
      ),
      IssueModel(
        id: '3',
        datetime: DateTime.now().subtract(const Duration(days: 3)),
        type: 'Issue',
        subtype: 'Pest Control',
        item: 'Field',
        farmerId: 'F001',
        fieldId: 'FIELD001',
        issueInput: 'Scout for aphid infestation',
        issueResponse: null,
        sdgAmount: null,
        status: 'Urgent',
        statusTime: DateTime.now(),
      ),
      IssueModel(
        id: '4',
        datetime: DateTime.now().subtract(const Duration(days: 4)),
        type: 'Info',
        subtype: 'Weather',
        item: 'Weather Station',
        farmerId: 'F001',
        fieldId: 'FIELD001',
        issueInput: 'Rain expected next week',
        issueResponse: 'Irrigation schedule adjusted',
        sdgAmount: null,
        status: 'Resolved',
        statusTime: DateTime.now().subtract(const Duration(days: 1)),
      ),
      IssueModel(
        id: '5',
        datetime: DateTime.now().subtract(const Duration(days: 5)),
        type: 'Alert',
        subtype: 'Equipment',
        item: 'Other',
        farmerId: 'F001',
        fieldId: 'FIELD001',
        issueInput: 'Tractor maintenance required',
        issueResponse: null,
        sdgAmount: 1200.0,
        status: 'Approved',
        statusTime: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  void _addIssue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddIssueScreen(
          onIssueAdded: (issue) {
            setState(() {
              issues.insert(0, issue);
            });
          },
        ),
      ),
    );
  }

  void _editIssue(IssueModel issue) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditIssueScreen(
          issue: issue,
          onIssueUpdated: (updatedIssue) {
            setState(() {
              final index = issues.indexWhere((i) => i.id == updatedIssue.id);
              if (index != -1) {
                issues[index] = updatedIssue;
              }
            });
          },
          onIssueDeleted: (deletedIssue) {
            setState(() {
              issues.removeWhere((i) => i.id == deletedIssue.id);
            });
          },
        ),
      ),
    );
  }

  List<IssueModel> get filteredIssues {
    List<IssueModel> filtered = issues;
    
    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((issue) {
        return issue.issueInput.toLowerCase().contains(searchQuery.toLowerCase()) ||
               issue.subtype.toLowerCase().contains(searchQuery.toLowerCase()) ||
               issue.type.toLowerCase().contains(searchQuery.toLowerCase()) ||
               issue.farmerId.toLowerCase().contains(searchQuery.toLowerCase()) ||
               issue.fieldId.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
    
    // Filter by status
    if (selectedFilter != 'All') {
      filtered = filtered.where((issue) => issue.status == selectedFilter).toList();
    }
    
    // Sort by date (newest first)
    filtered.sort((a, b) => b.datetime.compareTo(a.datetime));
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black08,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.eco_rounded,
                      color: AppColors.white,
                      size: 28,
                    ),
                  ),
                  const Text(
                    'Issues Register',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            
            // Farm Info Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Soba Farm',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text(
                                '82',
                                style: TextStyle(
                                  fontSize: 52,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Feddan',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.agriculture,
                          color: AppColors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Main wheat field with irrigation system installed last season.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.white,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.visibility_outlined,
                          size: 18,
                          color: AppColors.white,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'View Details',
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Search and Filter Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search issues, types, or farmers...',
                        border: InputBorder.none,
                        icon: Icon(Icons.search_rounded, color: AppColors.grey),
                        hintStyle: TextStyle(color: AppColors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Filter Chips
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFilterChip('All'),
                        _buildFilterChip('Urgent'),
                        _buildFilterChip('Approved'),
                        _buildFilterChip('Resolved'),
                        _buildFilterChip('Draft'),
                        _buildFilterChip('Cancelled'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Issues Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Issues Register',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        '${filteredIssues.length} issues found',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllIssuesScreen(issues: issues),
                            ),
                          );
                        },
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Issues List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _loadSampleIssues();
                  });
                },
                child: filteredIssues.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredIssues.length,
                        itemBuilder: (context, index) {
                          final issue = filteredIssues[index];
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300 + (index * 100)),
                            curve: Curves.easeInOut,
                            child: IssueCard(
                              issue: issue,
                              onTap: () => _editIssue(issue),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton.extended(
          onPressed: _addIssue,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'Add Issue',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          elevation: 8,
          extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (selected) {
          setState(() {
            selectedFilter = selected ? label : 'All';
          });
        },
        backgroundColor: AppColors.white,
        selectedColor: AppColors.primary.withOpacity(0.1),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.cardBorder,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 48,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No issues found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// 4. Issue Card Widget
class IssueCard extends StatelessWidget {
  final IssueModel issue;
  final VoidCallback onTap;

  const IssueCard({
    super.key,
    required this.issue,
    required this.onTap,
  });

  IconData _getIssueIcon(String subtype) {
    switch (subtype.toLowerCase()) {
      case 'irrigation':
        return Icons.water_drop_outlined;
      case 'fertilization':
        return Icons.grass_outlined;
      case 'pest control':
        return Icons.bug_report_outlined;
      case 'weather':
        return Icons.cloud_outlined;
      case 'equipment':
        return Icons.build_outlined;
      default:
        return Icons.warning_outlined;
    }
  }

  Color _getUrgencyColor(String status) {
    switch (status.toLowerCase()) {
      case 'urgent':
        return AppColors.urgentRed;
      case 'approved':
        return AppColors.warningOrange;
      case 'draft':
        return AppColors.infoBlue;
      case 'resolved':
        return AppColors.successGreen;
      case 'cancelled':
        return AppColors.grey;
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    // Issue Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getIssueIcon(issue.subtype),
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Issue Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  issue.issueInput,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getUrgencyColor(issue.status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  issue.status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _getUrgencyColor(issue.status),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  issue.type,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                issue.subtype,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(issue.datetime),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${issue.farmerId} • ${issue.fieldId}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (issue.sdgAmount != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.attach_money_rounded,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          Text(
                            '${issue.sdgAmount!.toStringAsFixed(0)} SDG',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// 5. Add Issue Screen
class AddIssueScreen extends StatefulWidget {
  final Function(IssueModel) onIssueAdded;

  const AddIssueScreen({super.key, required this.onIssueAdded});

  @override
  State<AddIssueScreen> createState() => _AddIssueScreenState();
}

class _AddIssueScreenState extends State<AddIssueScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _issueInputController = TextEditingController();
  final _farmerIdController = TextEditingController();
  final _fieldIdController = TextEditingController();
  final _sdgAmountController = TextEditingController();
  final _issueResponseController = TextEditingController();

  String selectedType = 'Issue';
  String selectedSubtype = 'Irrigation';
  String selectedItem = 'Field';
  String selectedStatus = 'Draft';
  DateTime selectedDate = DateTime.now();
  
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<String> issueTypes = ['Issue', 'Info', 'Alert'];
  final List<String> subtypes = ['Irrigation', 'Fertilization', 'Pest Control', 'Weather', 'Equipment', 'Other'];
  final List<String> items = ['Weather station', 'Satellite', 'Farmer', 'Field', 'Other'];
  final List<String> statuses = ['Draft', 'Approved', 'Resolved', 'Cancelled', 'Urgent'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _issueInputController.dispose();
    _farmerIdController.dispose();
    _fieldIdController.dispose();
    _sdgAmountController.dispose();
    _issueResponseController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _saveIssue() {
    if (_formKey.currentState!.validate()) {
      final newIssue = IssueModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        datetime: selectedDate,
        type: selectedType,
        subtype: selectedSubtype,
        item: selectedItem,
        farmerId: _farmerIdController.text.isEmpty ? 'F001' : _farmerIdController.text,
        fieldId: _fieldIdController.text.isEmpty ? 'FIELD001' : _fieldIdController.text,
        issueInput: _issueInputController.text,
        issueResponse: _issueResponseController.text.isEmpty ? null : _issueResponseController.text,
        sdgAmount: _sdgAmountController.text.isEmpty ? null : double.tryParse(_sdgAmountController.text),
        status: selectedStatus,
        statusTime: DateTime.now(),
      );

      widget.onIssueAdded(newIssue);
      Navigator.pop(context);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Issue added successfully'),
          backgroundColor: AppColors.successGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add New Issue',
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: _saveIssue,
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(_slideAnimation),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.add_task_rounded,
                          color: AppColors.white,
                          size: 32,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'New Issue Report',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Fill in the details below',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Basic Information Section
                  _buildSectionCard(
                    title: 'Basic Information',
                    icon: Icons.info_outline_rounded,
                    children: [
                      _buildDropdownField(
                        label: 'Issue Type',
                        value: selectedType,
                        items: issueTypes,
                        onChanged: (value) => setState(() => selectedType = value!),
                        icon: Icons.category_outlined,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildDropdownField(
                        label: 'Subtype',
                        value: selectedSubtype,
                        items: subtypes,
                        onChanged: (value) => setState(() => selectedSubtype = value!),
                        icon: Icons.label_outline_rounded,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildDropdownField(
                        label: 'Item',
                        value: selectedItem,
                        items: items,
                        onChanged: (value) => setState(() => selectedItem = value!),
                        icon: Icons.inventory_2_outlined,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildDateField(),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Issue Details Section
                  _buildSectionCard(
                    title: 'Issue Details',
                    icon: Icons.description_outlined,
                    children: [
                      _buildTextFormField(
                        controller: _issueInputController,
                        label: 'Issue Description',
                        hint: 'Describe the issue in detail...',
                        icon: Icons.edit_outlined,
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter issue description';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildTextFormField(
                        controller: _issueResponseController,
                        label: 'Response/Solution (Optional)',
                        hint: 'Enter response or solution if available...',
                        icon: Icons.lightbulb_outline_rounded,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Location & Cost Section
                  _buildSectionCard(
                    title: 'Location & Cost',
                    icon: Icons.place_outlined,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextFormField(
                              controller: _farmerIdController,
                              label: 'Farmer ID',
                              hint: 'F001',
                              icon: Icons.person_outline_rounded,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextFormField(
                              controller: _fieldIdController,
                              label: 'Field ID',
                              hint: 'FIELD001',
                              icon: Icons.landscape_outlined,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildTextFormField(
                        controller: _sdgAmountController,
                        label: 'SDG Amount (Optional)',
                        hint: '0.00',
                        icon: Icons.attach_money_rounded,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Status Section
                  _buildSectionCard(
                    title: 'Status',
                    icon: Icons.flag_outlined,
                    children: [
                      _buildDropdownField(
                        label: 'Issue Status',
                        value: selectedStatus,
                        items: statuses,
                        onChanged: (value) => setState(() => selectedStatus = value!),
                        icon: Icons.flag_circle_outlined,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                            side: const BorderSide(color: AppColors.cardBorder),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _saveIssue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 3,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save_outlined, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Save Issue',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.urgentRed),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.urgentRed, width: 2),
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.cardBorder),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.white,
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
                const SizedBox(width: 16),
                Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.black,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// 6. Edit Issue Screen
class EditIssueScreen extends StatefulWidget {
  final IssueModel issue;
  final Function(IssueModel) onIssueUpdated;
  final Function(IssueModel) onIssueDeleted;

  const EditIssueScreen({
    super.key,
    required this.issue,
    required this.onIssueUpdated,
    required this.onIssueDeleted,
  });

  @override
  State<EditIssueScreen> createState() => _EditIssueScreenState();
}

class _EditIssueScreenState extends State<EditIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _issueInputController;
  late TextEditingController _farmerIdController;
  late TextEditingController _fieldIdController;
  late TextEditingController _sdgAmountController;
  late TextEditingController _issueResponseController;

  late String selectedType;
  late String selectedSubtype;
  late String selectedItem;
  late String selectedStatus;
  late DateTime selectedDate;

  final List<String> issueTypes = ['Issue', 'Info', 'Alert'];
  final List<String> subtypes = ['Irrigation', 'Fertilization', 'Pest Control', 'Weather', 'Equipment', 'Other'];
  final List<String> items = ['Weather station', 'Satellite', 'Farmer', 'Field', 'Other'];
  final List<String> statuses = ['Draft', 'Approved', 'Resolved', 'Cancelled', 'Urgent'];

  @override
  void initState() {
    super.initState();
    _issueInputController = TextEditingController(text: widget.issue.issueInput);
    _farmerIdController = TextEditingController(text: widget.issue.farmerId);
    _fieldIdController = TextEditingController(text: widget.issue.fieldId);
    _sdgAmountController = TextEditingController(text: widget.issue.sdgAmount?.toString() ?? '');
    _issueResponseController = TextEditingController(text: widget.issue.issueResponse ?? '');
    
    selectedType = widget.issue.type;
    selectedSubtype = widget.issue.subtype;
    selectedItem = widget.issue.item;
    selectedStatus = widget.issue.status;
    selectedDate = widget.issue.datetime;
  }

  @override
  void dispose() {
    _issueInputController.dispose();
    _farmerIdController.dispose();
    _fieldIdController.dispose();
    _sdgAmountController.dispose();
    _issueResponseController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _updateIssue() {
    if (_formKey.currentState!.validate()) {
      final updatedIssue = widget.issue.copyWith(
        datetime: selectedDate,
        type: selectedType,
        subtype: selectedSubtype,
        item: selectedItem,
        farmerId: _farmerIdController.text,
        fieldId: _fieldIdController.text,
        issueInput: _issueInputController.text,
        issueResponse: _issueResponseController.text.isEmpty ? null : _issueResponseController.text,
        sdgAmount: _sdgAmountController.text.isEmpty ? null : double.tryParse(_sdgAmountController.text),
        status: selectedStatus,
        statusTime: DateTime.now(),
      );

      widget.onIssueUpdated(updatedIssue);
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Issue updated successfully'),
          backgroundColor: AppColors.successGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _deleteIssue() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Issue'),
        content: const Text('Are you sure you want to delete this issue? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.onIssueDeleted(widget.issue);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close edit screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Issue deleted successfully'),
                  backgroundColor: AppColors.urgentRed,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.urgentRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Issue',
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.urgentRed),
            onPressed: _deleteIssue,
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: _updateIssue,
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              child: const Text(
                'Update',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Same form fields as AddIssueScreen but with pre-filled values
              // ... (Similar implementation to AddIssueScreen)
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.cardBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _updateIssue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 3,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.update_outlined, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Update Issue',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// 7. All Issues Screen
class AllIssuesScreen extends StatefulWidget {
  final List<IssueModel> issues;

  const AllIssuesScreen({super.key, required this.issues});

  @override
  State<AllIssuesScreen> createState() => _AllIssuesScreenState();
}

class _AllIssuesScreenState extends State<AllIssuesScreen> {
  String searchQuery = '';
  String selectedFilter = 'All';

  List<IssueModel> get filteredIssues {
    List<IssueModel> filtered = widget.issues;
    
    if (searchQuery.isNot
