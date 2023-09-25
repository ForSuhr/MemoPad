function savePos(cardIndex, card) {
    cardManager.setX(cardIndex, card.x)
    cardManager.setY(cardIndex, card.y)
}

function saveSize(cardIndex, card) {
    cardManager.setWidth(cardIndex, card.width)
    cardManager.setHeight(cardIndex, card.height)
}
