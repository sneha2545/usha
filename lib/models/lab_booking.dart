enum LabBookingServiceType { diagnosticTest, healthPackage }

extension LabBookingServiceTypeLabel on LabBookingServiceType {
  String get label {
    switch (this) {
      case LabBookingServiceType.diagnosticTest:
        return 'Diagnostic test';
      case LabBookingServiceType.healthPackage:
        return 'Health package';
    }
  }
}

enum LabCollectionMethod { labVisit, homeCollection }

extension LabCollectionMethodLabel on LabCollectionMethod {
  String get label {
    switch (this) {
      case LabCollectionMethod.labVisit:
        return 'Lab Visit';
      case LabCollectionMethod.homeCollection:
        return 'Home Collection';
    }
  }
}

enum LabBookingStatus { confirmed, completed, cancelled }

extension LabBookingStatusLabel on LabBookingStatus {
  String get label {
    switch (this) {
      case LabBookingStatus.confirmed:
        return 'Confirmed';
      case LabBookingStatus.completed:
        return 'Completed';
      case LabBookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}

/// Catalog selection passed from a test or package detail sheet.
class LabBookingService {
  const LabBookingService({
    required this.type,
    required this.id,
    required this.name,
    required this.price,
    this.includedTestNames = const <String>[],
  });

  final LabBookingServiceType type;
  final String id;
  final String name;
  final int price;
  final List<String> includedTestNames;
}

/// A local laboratory booking with the details needed for later history.
class LabBooking {
  const LabBooking({
    required this.id,
    required this.laboratoryId,
    required this.laboratoryName,
    required this.laboratoryLocation,
    required this.serviceType,
    required this.serviceId,
    required this.serviceName,
    required this.price,
    required this.scheduledAt,
    required this.collectionMethod,
    required this.status,
    required this.createdAt,
    this.includedTestNames = const <String>[],
    this.collectionAddress,
  });

  final String id;
  final String laboratoryId;
  final String laboratoryName;
  final String laboratoryLocation;
  final LabBookingServiceType serviceType;
  final String serviceId;
  final String serviceName;
  final int price;
  final DateTime scheduledAt;
  final LabCollectionMethod collectionMethod;
  final String? collectionAddress;
  final List<String> includedTestNames;
  final LabBookingStatus status;
  final DateTime createdAt;

  String get priceLabel => '₹$price';

  LabBooking copyWith({LabBookingStatus? status}) {
    return LabBooking(
      id: id,
      laboratoryId: laboratoryId,
      laboratoryName: laboratoryName,
      laboratoryLocation: laboratoryLocation,
      serviceType: serviceType,
      serviceId: serviceId,
      serviceName: serviceName,
      price: price,
      scheduledAt: scheduledAt,
      collectionMethod: collectionMethod,
      collectionAddress: collectionAddress,
      includedTestNames: includedTestNames,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
