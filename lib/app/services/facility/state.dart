import 'model.dart';

sealed class FacilityListState {
  const FacilityListState();
}

final class FacilityListInitial extends FacilityListState {
  const FacilityListInitial();
}

final class FacilityListLoading extends FacilityListState {
  const FacilityListLoading();
}

final class FacilityListSuccess extends FacilityListState {
  final List<ReportFacility> facility;

  const FacilityListSuccess(this.facility);
}

final class FacilityListFailure extends FacilityListState {
  final String error;

  const FacilityListFailure(this.error);
}
