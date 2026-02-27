enum LoanPackageSearchBy { all, code, name }

class LoanPackageFilters {
  final LoanPackageSearchBy searchBy;
  final String query;

  const LoanPackageFilters({
    this.searchBy = LoanPackageSearchBy.all,
    this.query = "",
  });

  LoanPackageFilters copyWith({LoanPackageSearchBy? searchBy, String? query}) {
    return LoanPackageFilters(
      searchBy: searchBy ?? this.searchBy,
      query: query ?? this.query,
    );
  }
}

class LoanPackageRowModel {
  final String packageId;
  final String packageCode; // LP001
  final String packageName; // Quick Cash 30
  final int timePeriodDays; // 30
  final double interestRatePercent; // 10
  final DateTime createdDate;

  const LoanPackageRowModel({
    required this.packageId,
    required this.packageCode,
    required this.packageName,
    required this.timePeriodDays,
    required this.interestRatePercent,
    required this.createdDate,
  });

  factory LoanPackageRowModel.fromJson(Map<String, dynamic> json) {
    return LoanPackageRowModel(
      packageId: json['id']?.toString() ?? '',
      packageCode: json['packageCode'] ?? '',
      packageName: json['packageName'] ?? '',
      timePeriodDays: json['timePeriod'] ?? 0,
      interestRatePercent: (json['interest'] as num?)?.toDouble() ?? 0.0,
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : DateTime.now(),
    );
  }
}
