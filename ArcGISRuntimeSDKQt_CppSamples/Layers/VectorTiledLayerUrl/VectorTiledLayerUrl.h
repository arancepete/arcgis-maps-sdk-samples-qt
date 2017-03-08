// [WriteFile Name=VectorTiledLayerUrl, Category=Layers]
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

#ifndef VECTOR_TILED_LAYER_URL
#define VECTOR_TILED_LAYER_URL

namespace Esri
{
    namespace ArcGISRuntime
    {
        class Map;
        class MapQuickView;
    }
}

#include <QQuickItem>

class VectorTiledLayerUrl : public QQuickItem
{
    Q_OBJECT

public:
    explicit VectorTiledLayerUrl(QQuickItem* parent = 0);
    ~VectorTiledLayerUrl();

    void componentComplete() Q_DECL_OVERRIDE;
    Q_INVOKABLE void changeBasemap(QString basemap);

private:
    Esri::ArcGISRuntime::Map* m_map = nullptr;
    Esri::ArcGISRuntime::MapQuickView* m_mapView = nullptr;
};

#endif // VECTOR_TILED_LAYER_URL

