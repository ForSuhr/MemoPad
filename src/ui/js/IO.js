/*--------------------------load system----------------------------------*/
var canvasCardComponent = null
var noteCardComponent = null
var imageCardComponent = null
var arrowComponent = null
var canvasCardComponentFile = "../nodes/CanvasCard.qml"
var noteCardComponentFile = "../nodes/NoteCard.qml"
var imageCardComponentFile = "../nodes/ImageCard.qml"
var arrowComponentFile = "../edges/Arrow.qml"

function loadCanvas(canvasID) {
    // clear undo and redo stack of the previous canvas
    CommandManager.clearUndoStack()
    CommandManager.clearRedoStack()

    // unload previous canvas, load next canvas
    unload(bgCanvas.edgeLayer)
    unload(bgCanvas.nodeLayer)
    load(canvasID)
}

// unload all cards inside the nodeLayer, because nodeLayer is the container of all cards
function unload(layer) {
    for (var i = 0; i < layer.children.length; i++)
        layer.children[i].destroy()
}

function load(canvasID) {
    CardManager.loadCanvas(canvasID)
    var cardNum = CardManager.cardNum()
    var cardIDs = CardManager.cardIDs()
    // load nodes firstly
    for (var i = 0; i < cardNum; i++) {
        var cardID = cardIDs[i]
        var cardType = CardManager.cardType(cardID)
        switch (cardType) {
        case "canvas":
            loadComponent(canvasCardComponent, canvasCardComponentFile, cardID)
            break
        case "note":
            loadComponent(noteCardComponent, noteCardComponentFile, cardID)
            break
        case "image":
            loadComponent(imageCardComponent, imageCardComponentFile, cardID)
            break
        }
    }
    // load edges secondly
    for (i = 0; i < cardNum; i++) {
        cardID = cardIDs[i]
        cardType = CardManager.cardType(cardID)
        switch (cardType) {
        case "arrow":
            loadComponent(arrowComponent, arrowComponentFile, cardID)
            break
        }
    }
}

function loadComponent(cardComponent, cardComponentFile, cardID) {
    // avoid duplicate loading
    if (cardComponent !== null) {
        createCard(cardComponent, cardID)
        return
    }

    cardComponent = Qt.createComponent(cardComponentFile)
    if (cardComponent.status === Component.Loading)
        cardComponent.statusChanged.connect(createCard)
    else
        createCard(cardComponent, cardID)
}

function createCard(cardComponent, cardID) {
    // determine parent item, which is the container for nodes and edges
    var cardType = CardManager.cardType(cardID)
    var parentItem = cardType === "arrow" ? bgCanvas.edgeLayer : bgCanvas.nodeLayer

    // create card from the loaded component
    if (cardComponent.status === Component.Ready) {
        // set card layer as its parent
        var card = cardComponent.createObject(parentItem, {
                                                  "x": CardManager.x(cardID),
                                                  "y": CardManager.y(cardID),
                                                  "z": CardManager.z(cardID),
                                                  "cardID": cardID
                                              })

        card.loaded = true
    } else {
        console.error("Error loading component:", cardComponent.errorString())
    }
}

/*--------------------------query system---------------------------*/
function getNodeById(cardID) {
    var parentItem = bgCanvas.nodeLayer
    for (var i = 0; i < parentItem.children.length; i++) {
        var currentID = parentItem.children[i].cardID
        if (currentID === cardID)
            return parentItem.children[i]
    }
}

function getEdgeById(cardID) {
    var parentItem = bgCanvas.edgeLayer
    for (var i = 0; i < parentItem.children.length; i++) {
        var currentID = parentItem.children[i].cardID
        if (currentID === cardID)
            return parentItem.children[i]
    }
}

/*--------------------------save system----------------------------------*/
function savePos(cardID, card, stackCommand = true) {
    var lastX = CardManager.x(cardID)
    var lastY = CardManager.y(cardID)
    var lastZ = CardManager.z(cardID)
    var currentX = card.x
    var currentY = card.y
    var currentZ = card.z
    if (lastX !== currentX | lastY !== currentY | lastZ !== currentZ) {
        // stack command
        if (stackCommand)
            CommandManager.moveCard(cardID, lastX, lastY, lastZ, currentX,
                                    currentY, currentZ)
        // save to settings file
        CardManager.setPos(cardID, currentX, currentY, currentZ)
    }
}

function saveSize(cardID, card, stackCommand = true) {
    var lastWidth = CardManager.width(cardID)
    var lastHeight = CardManager.height(cardID)
    var currentWidth = card.width
    var currentHeight = card.height
    if (lastWidth !== currentWidth | lastHeight !== currentHeight) {
        if (stackCommand)
            CommandManager.resizeCard(cardID, lastWidth, lastHeight,
                                      currentWidth, currentHeight)
        CardManager.setSize(cardID, currentWidth, currentHeight)
    }
}

// transform = move + resize
function saveTransform(cardID, card, stackCommand = true) {
    var lastX = CardManager.x(cardID)
    var lastY = CardManager.y(cardID)
    var lastZ = CardManager.z(cardID)
    var currentX = card.x
    var currentY = card.y
    var currentZ = card.z
    var lastWidth = CardManager.width(cardID)
    var lastHeight = CardManager.height(cardID)
    var currentWidth = card.width
    var currentHeight = card.height
    if (lastX !== currentX | lastY !== currentY | lastZ !== currentZ | lastWidth
            !== currentWidth | lastHeight !== currentHeight) {
        if (stackCommand)
            CommandManager.transformCard(cardID, lastX, lastY, lastZ, currentX,
                                         currentY, currentZ, lastWidth,
                                         lastHeight, currentWidth,
                                         currentHeight)
        CardManager.setPos(cardID, currentX, currentY, currentZ)
        CardManager.setSize(cardID, currentWidth, currentHeight)
    }
}

function saveText(cardID, card, stackCommand = true) {
    var lastText = CardManager.text(cardID)
    var currentText = card.text
    if (lastText !== currentText) {
        if (stackCommand)
            CommandManager.changeText(cardID, lastText, currentText)
        CardManager.setText(cardID, currentText)
    }
}

function saveImage(cardID, imageSource) {
    CardManager.setImage(cardID, imageSource)
}

function saveCardBackgroundColor(cardID, card, stackCommand = true) {
    var lastColor = CardManager.backgroundColor(cardID)
    var currentColor = card.backgroundColor
    if (lastColor !== currentColor) {
        if (stackCommand)
            CommandManager.changeBackgroundColor(cardID, lastColor,
                                                 currentColor)
        CardManager.setBackgroundColor(cardID, currentColor)
    }
}

// canvas card
function saveCanvasID(cardID, card, stackCommand = true) {
    CardManager.setCanvasID(cardID, card.canvasID)
}

function saveCanvasName(cardID, card, stackCommand = true) {
    CardManager.setCanvasName(cardID, card.canvasName)
}

// arrow card
function saveFromCard(cardID, card, stackCommand = true) {
    var lastFromCardID = CardManager.fromCardID(cardID)
    var currentFromCardID = card.fromCardID
    var lastFromDirection = CardManager.fromCardDirection(cardID)
    var currentFromDirection = card.fromDirection
    var lastFromX = CardManager.fromX(cardID)
    var currentFromX = card.arrowFromX
    var lastFromY = CardManager.fromY(cardID)
    var currentFromY = card.arrowFromY
    if (lastFromCardID !== currentFromCardID | lastFromDirection !== currentFromDirection) {
        if (stackCommand)
            CommandManager.changeFromCard(cardID, lastFromCardID,
                                          lastFromDirection, lastFromX,
                                          lastFromY, currentFromCardID,
                                          currentFromDirection, currentFromX,
                                          currentFromY)
        CardManager.setFromCardID(cardID, currentFromCardID)
        CardManager.setFromCardDirection(cardID, currentFromDirection)
    }
}

function saveToCard(cardID, card, stackCommand = true) {
    var lastToCardID = CardManager.toCardID(cardID)
    var currentToCardID = card.toCardID
    var lastToDirection = CardManager.toCardDirection(cardID)
    var currentToDirection = card.toDirection
    var lastToX = CardManager.toX(cardID)
    var currentToX = card.arrowToX
    var lastToY = CardManager.toY(cardID)
    var currentToY = card.arrowToY
    if (lastToCardID !== currentToCardID | lastToDirection !== currentToDirection) {
        if (stackCommand)
            CommandManager.changeToCard(cardID, lastToCardID, lastToDirection,
                                        lastToX, lastToY, currentToCardID,
                                        currentToDirection, currentToX,
                                        currentToY)
        CardManager.setToCardID(cardID, currentToCardID)
        CardManager.setToCardDirection(cardID, currentToDirection)
    }
}

function saveArrowPos(cardID, card, stackCommand = true) {
    var lastFromX = CardManager.fromX(cardID)
    var currentFromX = card.arrowFromX
    var lastFromY = CardManager.fromY(cardID)
    var currentFromY = card.arrowFromY
    var lastToX = CardManager.toX(cardID)
    var currentToX = card.arrowToX
    var lastToY = CardManager.toY(cardID)
    var currentToY = card.arrowToY
    var lastControlX = CardManager.controlX(cardID)
    var currentControlX = card.arrowControlX
    var lastControlY = CardManager.controlY(cardID)
    var currentControlY = card.arrowControlY
    if (lastFromX !== currentFromX | lastFromY !== currentFromY | lastToX
            !== currentToX | lastToY !== currentToY | lastControlX
            !== currentControlX | lastControlY !== currentControlY) {
        if (stackCommand)
            CommandManager.changeArrowPos(cardID, lastFromX,
                                          lastFromY, lastToX,
                                          lastToY, lastControlX,
                                          lastControlY, currentFromX,
                                          currentFromY, currentToX,
                                          currentToY, currentControlX,
                                          currentControlY)
        CardManager.setFromX(cardID, currentFromX)
        CardManager.setFromY(cardID, currentFromY)
        CardManager.setToX(cardID, currentToX)
        CardManager.setToY(cardID, currentToY)
        CardManager.setControlX(cardID, currentControlX)
        CardManager.setControlY(cardID, currentControlY)
    }
}

function saveStrokeStyle(cardID, card, stackCommand = true) {
    CardManager.setStrokeStyle(cardID, card.arrowStrokeStyle)
}

/*--------------------------canvas------------------------------*/
function saveCurrentCanvasColor(color, stackCommand = true) {
    CardManager.setCurrentCanvasColor(color)
}

function saveCanvasColor(canvasID, color, stackCommand = true) {
    CardManager.setCanvasColor(canvasID, color)
}

/*---------------------------delete--------------------------------------*/
function deleteCard(cardID, card) {
    CardManager.deleteCard(cardID)
    card.destroy()
}
