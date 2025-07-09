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

class _AddIssueScreenState extends State<AddIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _issueInputController = TextEditingController();
  final _farmerIdController = Text
