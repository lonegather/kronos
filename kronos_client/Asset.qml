import QtQuick 2.0
import kronos.entity 1.0

AssetForm {
    EntityModel {
        id: entityModel
    }

    Connections {
        target: header
        onProjectChanged: {
            gridView.model = []
            entityModel.update(["project", header.currentProject, "genus", "asset"])
        }
    }
    Connections {
        target: entityModel
        onDataChanged: {
            gridView.model = entityModel
        }
    }
}
