var cardComponent = null
var draggedCard = null
var onPressedMouse
var mouseAreaPosInWindow

function startDrag(mouse) {
    // get the mouse area position in window
    mouseAreaPosInWindow = root.mapToItem(window.contentItem, 0, 0)
    // store the mouse position(relative to mouse area) when mouse is pressed
    onPressedMouse = {
        "x": mouse.x,
        "y": mouse.y
    }
    loadComponent(mouse)
}

function loadComponent(mouse) {
    // avoid duplicate loading
    if (cardComponent != null) {
        createCard(mouse)
        return
    }

    cardComponent = Qt.createComponent(
                root.componentFile) // create card according to the given qml file, e.g. "NoteCard.qml"
    if (cardComponent.status === Component.Loading)
        cardComponent.statusChanged.connect(createCard)
    else
        createCard(mouse)
}

function createCard(mouse) {
    // determine parent item, which is the container for nodes and edges
    var parentItem = root.componentFile
            === "../edges/Arrow.qml" ? bgCanvas.edgeLayer : bgCanvas.nodeLayer

    // create card from the loaded component
    if (cardComponent.status === Component.Ready && draggedCard == null) {
        // set card layer as its parent
        draggedCard = cardComponent.createObject(parentItem, {
                                                     "x": root.mapToItem(
                                                              parentItem,
                                                              mouse.x,
                                                              mouse.y).x - onPressedMouse.x,
                                                     "y": root.mapToItem(
                                                              parentItem,
                                                              mouse.x,
                                                              mouse.y).y - onPressedMouse.y
                                                 })
    } else
        console.log(cardComponent.errorString())
}

function continueDrag(mouse) {
    if (draggedCard == null)
        return

    draggedCard.x = root.mapToItem(bgCanvas.nodeLayer, mouse.x,
                                   mouse.y).x - onPressedMouse.x
    draggedCard.y = root.mapToItem(bgCanvas.nodeLayer, mouse.x,
                                   mouse.y).y - onPressedMouse.y
}

function endDrag(mouse) {
    if (draggedCard === null)
        return

    draggedCard.created = true
    draggedCard = null
}
