import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mbungeweb/models/add_admin.dart';
import 'package:mbungeweb/models/add_event.dart';
import 'package:mbungeweb/models/add_mp.dart';
import 'package:mbungeweb/models/edit_event.dart';
import 'package:mbungeweb/models/edit_mp.dart';
import 'package:mbungeweb/models/edit_webinar.dart';
import 'package:mbungeweb/models/user_model.dart';
import 'package:mbungeweb/models/add_webinar.dart';
import 'package:mbungeweb/models/admin_model.dart';
import 'package:mbungeweb/models/event.dart';
import 'package:mbungeweb/models/metrics.dart';
import 'package:mbungeweb/models/mp_model.dart';
import 'package:mbungeweb/models/webinar.dart';
import 'package:mbungeweb/models/webinar_questions.dart';
import 'package:mbungeweb/utils/http.dart';

part 'metrics_repo.dart';
part 'events_repo.dart';
part 'mp_repo.dart';
part 'admin_repo.dart';
part 'webinar_repo.dart';
