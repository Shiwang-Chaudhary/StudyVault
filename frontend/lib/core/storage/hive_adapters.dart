import 'package:hive_ce/hive_ce.dart';
import 'package:study_vault/features/notes/data/models/local_pdf_model.dart';

@GenerateAdapters([AdapterSpec<LocalPdfModel>()])
part 'hive_adapters.g.dart';
