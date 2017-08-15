// [WriteFile Name=DistanceCompositeSymbol, Category=Scenes]
// [Legal]
// Copyright 2016 Esri.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// [Legal]

import QtQuick 2.6
import QtQuick.Controls 1.4
import Esri.Samples 1.0
import Esri.ArcGISExtras 1.1

DistanceCompositeSymbolSample {
    width: 800
    height: 600
    
    property url dataPath: System.userHomePath + "/ArcGIS/Runtime/Data/3D/SkyCrane/SkyCrane.lwo"

    // add a mapView component
    SceneView {
        anchors.fill: parent
        objectName: "sceneView"
    }
}