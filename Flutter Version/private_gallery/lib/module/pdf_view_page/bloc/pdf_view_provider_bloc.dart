
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pdf_view_provider_event.dart';
part 'pdf_view_provider_state.dart';

class PdfViewProviderBloc extends Bloc<PdfViewProviderEvent, PdfViewProviderState> {
  PdfViewProviderBloc() : super(PdfViewProviderInitial()) {
    on<PdfViewProviderEvent>((event, emit) {});
  }
}
