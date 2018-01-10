import QtQuick 2.7

AssetForm {
    Connections {
        target: header
        onProjectChanged: {
            console.log("projectChanged")
            gridView.model = []
            entityModel.update(["project", header.currentProject, "genus", "asset"])
        }
    }

    Connections {
        target: entityModel
        onDataChanged: {
            console.log("dataChanged")
            gridView.model = entityModel
        }
    }
}
