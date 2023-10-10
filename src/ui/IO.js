/*--------------------------load system----------------------------------*/
var canvasCardComponent = null
var noteCardComponent = null
var imageCardComponent = null
var canvasCardComponentFile = "CanvasCard.qml"
var noteCardComponentFile = "NoteCard.qml"
var imageCardComponentFile = "ImageCard.qml"

function loadCanvas(canvasID) {
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
        var id = cardIDs[i]
        var cardType = CardManager.cardType(id)
        switch (cardType) {
        case "canvas":
            loadComponent(canvasCardComponent, canvasCardComponentFile, id)
            break
        case "note":
            loadComponent(noteCardComponent, noteCardComponentFile, id)
            break
        case "image":
            loadComponent(imageCardComponent, imageCardComponentFile, id)
            break
        }
    }
}

function loadComponent(cardComponent, cardComponentFile, id) {
    // avoid duplicate loading
    if (cardComponent !== null) {
        createCard(cardComponent, id)
        return
    }

    cardComponent = Qt.createComponent(cardComponentFile)
    if (cardComponent.status === Component.Loading)
        cardComponent.statusChanged.connect(createCard)
    else
        createCard(cardComponent, id)
}

function createCard(cardComponent, id) {
    // create card from the loaded component
    if (cardComponent.status === Component.Ready) {
        // set card layer as its parent
        var card = cardComponent.createObject(bgCanvas.cardLayer, {
                                                  "x": CardManager.x(id),
                                                  "y": CardManager.y(id),
                                                  "z": CardManager.z(id),
                                                  "id": id
                                              })

        card.loaded = true
    }
}

/*--------------------------save system----------------------------------*/
function savePos(id, card, stackCommand = true) {
    var lastX = CardManager.x(id)
    var lastY = CardManager.y(id)
    var lastZ = CardManager.z(id)
    var currentX = card.x
    var currentY = card.y
    var currentZ = card.z
    if (lastX !== currentX | lastY !== currentY | lastZ !== currentZ) {
        // stack command
        if (stackCommand)
            CommandManager.moveCard(id, lastX, lastY, lastZ, currentX,
                                    currentY, currentZ)
        // save to settings file
        CardManager.setPos(id, currentX, currentY, currentZ)
    }
}

function saveSize(id, card, stackCommand = true) {
    var lastWidth = CardManager.width(id)
    var lastHeight = CardManager.height(id)
    var currentWidth = card.width
    var currentHeight = card.height
    if (lastWidth !== currentWidth | lastHeight !== currentHeight) {
        if (stackCommand)
            CommandManager.resizeCard(id, lastWidth, lastHeight, currentWidth,
                                      currentHeight)
        CardManager.setSize(id, currentWidth, currentHeight)
    }
}

// transform = move + resize
function saveTransform(id, card, stackCommand = true) {
    var lastX = CardManager.x(id)
    var lastY = CardManager.y(id)
    var lastZ = CardManager.z(id)
    var currentX = card.x
    var currentY = card.y
    var currentZ = card.z
    var lastWidth = CardManager.width(id)
    var lastHeight = CardManager.height(id)
    var currentWidth = card.width
    var currentHeight = card.height
    if (lastX !== currentX | lastY !== currentY | lastZ !== currentZ | lastWidth
            !== currentWidth | lastHeight !== currentHeight) {
        if (stackCommand)
            CommandManager.transformCard(id, lastX, lastY, lastZ, currentX,
                                         currentY, currentZ, lastWidth,
                                         lastHeight, currentWidth,
                                         currentHeight)
        CardManager.setPos(id, currentX, currentY, currentZ)
        CardManager.setSize(id, currentWidth, currentHeight)
    }
}

function saveText(id, card, stackCommand = true) {
    var lastText = CardManager.text(id)
    var currentText = card.text
    if (lastText !== currentText) {
        if (stackCommand)
            CommandManager.changeText(id, lastText, currentText)
        CardManager.setText(id, currentText)
    }
}

function saveBackgroundColor(id, card, stackCommand = true) {
    var lastColor = CardManager.backgroundColor(id)
    var currentColor = card.backgroundColor
    if (lastColor !== currentColor) {
        if (stackCommand)
            CommandManager.changeBackgroundColor(id, lastColor, currentColor)
        CardManager.setBackgroundColor(id, currentColor)
    }
}

function saveCanvasID(id, card, stackCommand = true) {
    CardManager.setCanvasID(id, card.canvasID)
}

function saveCanvasName(id, card, stackCommand = true) {
    CardManager.setCanvasName(id, card.canvasName)
}

/*---------------------------delete--------------------------------------*/
function deleteCard(id, card) {
    CardManager.deleteCard(id)
    card.destroy()
}
