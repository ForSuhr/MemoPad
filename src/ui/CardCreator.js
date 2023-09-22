var cardComponent = null
var draggedCard = null
var onPressedMouse
var mouseAreaPosInWindow

function startDrag(mouse) {
    // get the mouse area position in window
    mouseAreaPosInWindow = root.mapToItem(sideToolBar, 0, 0)
    // store the mouse position(relative to mouse area) when mouse is pressed
    onPressedMouse = {
        "x": mouse.x,
        "y": mouse.y
    }
    loadComponent()
}

function loadComponent() {
    // avoid duplicate loadding
    if (cardComponent != null) {
        createCard()
        return
    }

    cardComponent = Qt.createComponent(
                root.componentFile) // create card according to the given qml file, e.g. "NoteCard.qml"
    if (cardComponent.status === Component.Loading)
        cardComponent.statusChanged.connect(createCard)
    else
        createCard()
}

function createCard() {
    // create card from the loaded component
    if (cardComponent.status === Component.Ready && draggedCard == null) {
        // set card layer as its parent
        draggedCard = cardComponent.createObject(bgCanvas, {
                                                     "x": mouseAreaPosInWindow.x,
                                                     "y": mouseAreaPosInWindow.y
                                                 })
    }
}

function continueDrag(mouse) {
    if (draggedCard == null)
        return

    draggedCard.x = mouse.x + mouseAreaPosInWindow.x - onPressedMouse.x - bgCanvas.x
    draggedCard.y = mouse.y + mouseAreaPosInWindow.y - onPressedMouse.y - bgCanvas.y
}

function endDrag(mouse) {
    if (draggedCard === null)
        return

    draggedCard.created = true
    draggedCard = null
}
