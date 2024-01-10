var dotInterval = Globals.dotInterval

function snap(obj) {
    // compute the position of the nearest dot
    var gridX = Math.floor(
                (obj.x + dotInterval / 2) / dotInterval) * dotInterval
    var gridY = Math.floor(
                (obj.y + dotInterval / 2) / dotInterval) * dotInterval

    // snap!!!
    obj.x = gridX
    obj.y = gridY

    // adjust width and height
    obj.width = Math.floor(
                (obj.width + dotInterval / 2) / dotInterval) * dotInterval
    obj.height = Math.floor(
                (obj.height + dotInterval / 2) / dotInterval) * dotInterval
}
