const utilities = require('./utilities.js');

(async function runner () {
  try {
    // Get all configuration files
    const configurations = await utilities.getFilesRecursively('./non-production').then(configuration => configuration.map(application => {
      // Ensure each configuration has the correct keys and/or tags
      const missingConfiguration = utilities.checkKeys(application, ['name', 'email', 'environments', 'tags'])
      const missingRequiredTags = utilities.checkKeys(application.tags, ['business-unit', 'application', 'is-production', 'owner'])
      const missingOptionalTags = utilities.checkKeys(application.tags, ['environment-name', 'component', 'infrastructure-support', 'runbook', 'source-code'], false)

      return {
        ...application,
        ...{
          missing: {
            required: missingConfiguration.concat(missingRequiredTags),
            optional: missingOptionalTags
          }
        }
      }
    }))

    // Filter out configurations with missing required keys
    const missingRequired = configurations.filter(configuration => configuration.missing.required.length)

    // If there are any, throw an error
    if (missingRequired.length) {
      const e = missingRequired.map(configuration => `${configuration.name} is missing: ${configuration.missing.required.join(', ')}`).join('\n')
      throw new Error(`[REQUIRED]: Configuration is missing:\n${e}`)
    }

    // Filter out configurations with missing optional keys
    const missingOptional = configurations.filter(configuration => configuration.missing.optional.length)

    // If there are any, console.warn a user
    if (missingOptional.length) {
      const message = missingOptional.map(configuration => `${configuration.name} is missing: ${configuration.missing.optional.join(', ')}`).join('\n')

      console.warn(`Warning: ${message}`)
    }
  } catch (e) {
    console.error(e)
    process.exit(1)
  }
})()
