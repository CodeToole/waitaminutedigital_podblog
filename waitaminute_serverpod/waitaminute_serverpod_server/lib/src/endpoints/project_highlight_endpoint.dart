import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint for managing portfolio and carousel project highlights (CRUD).
class ProjectHighlightEndpoint extends Endpoint {
  /// Fetches all project highlights sorted by display order priority.
  Future<List<ProjectHighlight>> getHighlights(Session session) async {
    return await ProjectHighlight.db.find(
      session,
      orderBy: (t) => t.order,
      orderDescending: false,
    );
  }

  /// Saves a project highlight (insert or update).
  Future<ProjectHighlight> saveHighlight(
    Session session,
    ProjectHighlight project,
  ) async {
    if (project.id != null) {
      return await ProjectHighlight.db.updateRow(session, project);
    } else {
      return await ProjectHighlight.db.insertRow(session, project);
    }
  }

  /// Deletes a project highlight by its database ID.
  Future<bool> deleteHighlight(Session session, int id) async {
    final highlight = await ProjectHighlight.db.findById(session, id);
    if (highlight != null) {
      await ProjectHighlight.db.deleteRow(session, highlight);
      return true;
    }
    return false;
  }
}
