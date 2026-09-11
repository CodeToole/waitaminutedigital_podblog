import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint for prospect lead inquiries and admin review.
class LeadEndpoint extends Endpoint {
  /// Submits a discovery inquiry from prospective clients (public).
  Future<LeadInquiry> submitInquiry(
    Session session,
    LeadInquiry lead,
  ) async {
    return await LeadInquiry.db.insertRow(session, lead);
  }

  /// Fetches received inquiries sorted by newest first (admin only).
  Future<List<LeadInquiry>> getInquiries(Session session) async {
    return await LeadInquiry.db.find(
      session,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }
}
