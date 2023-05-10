#!/usr/bin/env node
const fs = require('fs/promises');

let debug = false

const delay = ms => new Promise(resolve => setTimeout(resolve, ms))
const wait = async ({ wait }) => { await delay(wait); return 1 }
function getArgs () {
  const args = {};
  process.argv
      .slice(2, process.argv.length)
      .forEach( arg => {
      // long arg
      if (arg.slice(0,2) === '--') {
          const longArg = arg.split('=');
          const longArgFlag = longArg[0].slice(2,longArg[0].length);
          const longArgValue = longArg.length > 1 ? longArg[1] : true;
          args[longArgFlag] = longArgValue;
      }
      // flags
      else if (arg[0] === '-') {
          const flags = arg.slice(1,arg.length).split('');
          flags.forEach(flag => {
          args[flag] = true;
          });
      }
  });
  return args;
}
const setDebugFlag = (debugFlag) => {
  const parsed = debugFlag ? debugFlag.toString().toLowerCase() : ''
  debug = debugFlag === '1' || debugFlag === true || parsed === 'true' ? true : false
  if (debug) console.log('Debug mode enabled')
}

const readFile = async({ fileName }) => {
  try {
    const data = await fs.readFile(`./${fileName}`, { encoding: 'utf8' })
    if (debug) console.log(data)
    return data
  } catch (err) {
    console.error(err);
  }
}

const writeFile = async({ fileName, data }) => {
  try {
    await fs.writeFile(`./${fileName}`, JSON.stringify(data), { encoding: 'utf8' })
    return fileName
  } catch (err) {
    console.error(err);
  }
}

// Main
async function main() {
  const args = getArgs()
  setDebugFlag(args.debug || args.d)

  if (args.h || args.help) {
    console.log(`
      About

      Flags:

        -d --debug        Debug mode
    `)
    return true
  }

  await wait({ wait: args.wait || 1000 })

  console.log('Done')
}

main()
  .then(() => {
  })
  .catch(err => {
    console.error(err)
    process.exit(1)
  })
  .finally(() => {
    process.exit(0)
  })
