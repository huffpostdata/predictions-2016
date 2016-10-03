#!/usr/bin/env node

'use strict'

process.env.FONTCONFIG_PATH = `${__dirname}/fonts`

const fs = require('fs')
const Canvas = require('canvas')

const TrumpImage = new Canvas.Image
const ClintonImage = new Canvas.Image

function Trump(i) {
  this.color = '#e52426'
  this.name = 'TRUMP'
  this.slug = 'trump'
  this.percent = `${i}%`
  this.image = TrumpImage
  this.imagePosition = 'right'
}

function Clinton(i) {
  this.color = '#4c7de0'
  this.name = 'CLINTON'
  this.slug = 'clinton'
  this.percent = `${i}%`
  this.image = ClintonImage
  this.imagePosition = 'left'
}

function generate(aspectRatio, ahead, behind) {
  var landscape = (aspectRatio === 'landscape')
  var left = landscape ? 100 : 0

  var canvas = new Canvas(landscape ? 400 : 200, 200)
  var ctx = canvas.getContext('2d')

  ctx.fillStyle = 'white'
  ctx.fillRect(0, 0, landscape ? 400 : 200, 200)

  ctx.drawImage(ahead.image, left + (ahead.imagePosition === 'left' ? 0 : 80), 10, 120, 120)

  ctx.font = '20px Proxima Nova Cn Th Extrabold'
  ctx.fillStyle = 'black'
  if (ahead.imagePosition === 'left') {
    ctx.textAlign = 'right'
    ctx.fillText('chance of', left + 190, 100)
    ctx.fillText('winning', left + 190, 118)
  } else {
    ctx.textAlign = 'left'
    ctx.fillText('chance of', left + 10, 100)
    ctx.fillText('winning', left + 10, 118)
  }

  ctx.textAlign = 'center'

  ctx.fillStyle = ahead.color
  ctx.fillRect(left, 130, 200, 38)
  ctx.font = '32px Proxima Nova Cn Th Extrabold'
  ctx.fillStyle = 'white'
  ctx.fillText(`${ahead.name}: ${ahead.percent}`, left + 100, 160)

  ctx.font = '24px Proxima Nova Cn Th Extrabold'
  ctx.fillStyle = behind.color
  ctx.fillText(`${behind.name}: ${behind.percent}`, left + 100, 192)

  return canvas.toBuffer()
}

function generateAll(aspectRatio) {
  const all = [];

  for (let i = 0; i <= 100; i++) {
    if (i < 50) {
      all.push(generate(aspectRatio, new Trump(100 - i), new Clinton(i)))
    } else {
      all.push(generate(aspectRatio, new Clinton(i), new Trump(100 - i)))
    }
  }

  return all;
}

function generateIfAllImagesLoaded() {
  generateIfAllImagesLoaded.nRemaining -= 1
  if (generateIfAllImagesLoaded.nRemaining === 0) {
    generateAll('square').map((png, i) => {
      fs.writeFileSync(`${__dirname}/output/${i}.png`, png)
    })
    generateAll('landscape').map((png, i) => {
      fs.writeFileSync(`${__dirname}/output/${i}-landscape.png`, png)
    })
  }
}
generateIfAllImagesLoaded.nRemaining = 2
TrumpImage.onload = generateIfAllImagesLoaded
TrumpImage.src = `${__dirname}/../assets/images/trump-bust.jpg`
ClintonImage.onload = generateIfAllImagesLoaded
ClintonImage.src = `${__dirname}/../assets/images/clinton-bust.jpg`
