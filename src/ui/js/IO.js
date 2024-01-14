/*--------------------------load system----------------------------------*/
var canvasCardComponent = null
var noteCardComponent = null
var imageCardComponent = null
var canvasCardComponentFile = "../nodes/CanvasCard.qml"
var noteCardComponentFile = "../nodes/NoteCard.qml"
var imageCardComponentFile = "../nodes/ImageCard.qml"
var arrowComponentFile = "../edges/Arrow.qml"

function loadCanvas(canvasID) {
    // clear undo and redo stack of the previous canvas
    CommandManager.clearUndoStack()
    CommandManager.clearRedoStack()

    // unload previous canvas, load next canvas
    unload(bgCanvas.cardLayer)
    load(canvasID)
}

// unload all cards inside the cardLayer, because cardLayer is the container of all cards
function unload(cardLayer) {
    for (var i = 0; i < cardLayer.children.length; i++)
        cardLayer.children[i].destroy()
}

function load(canvasID) {
    CardManager.loadCanvas(canvasID)
    var cardNum = CardManager.cardNum()
    var cardIDs = CardManager.cardIDs()
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
    // create card from the loaded component
    if (cardComponent.status === Component.Ready) {
        // set card layer as its parent
        var card = cardComponent.createObject(bgCanvas.cardLayer, {
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
function getCardById(cardID) {
    var cardLayer = bgCanvas.cardLayer
    for (var i = 0; i < cardLayer.children.length; i++) {
        var currentID = cardLayer.children[i].cardID
        if (currentID === cardID)
            return cardLayer.children[i]
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

function saveCanvasID(cardID, card, stackCommand = true) {
    CardManager.setCanvasID(cardID, card.canvasID)
}

function saveCanvasName(cardID, card, stackCommand = true) {
    CardManager.setCanvasName(cardID, card.canvasName)
}

/*--------------------------canvas------------------------------*/
function saveCurrentCanvasColor(color, stackCommand = true) {
    CardManager.setCurrentCanvasColor(color)
}

/*---------------------------delete--------------------------------------*/
function deleteCard(cardID, card) {
    CardManager.deleteCard(cardID)
    card.destroy()
}
