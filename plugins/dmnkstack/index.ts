import { mkdir, readdir, readFile, writeFile } from 'node:fs/promises'
import os from 'node:os'
import path from 'node:path'

import type { PluginAPI } from '@ampcode/plugin'

export const description =
	'Dmnkstack: model-first routing for coding work and its skills. Seeds ~/.config/dmnkstack/models.md from the setup-dmnkstack defaults when it is missing.'

// A fresh orb has no Dmnkstack config. Seed models.md from the setup defaults so routing works
// at once; never overwrite an existing file, so a local or dotfiles-linked config wins.
async function seedModels(amp: PluginAPI) {
	const configHome = process.env.XDG_CONFIG_HOME || path.join(os.homedir(), '.config')
	const target = path.join(configHome, 'dmnkstack', 'models.md')
	const defaults = await readFile(
		path.join(import.meta.dirname, 'skills/setup-dmnkstack/references/default-models.md'),
		'utf8',
	)
	const map = defaults.match(/```md\n([\s\S]*?)```/)?.[1]
	if (!map) {
		amp.logger.log('dmnkstack: no model map found in default-models.md')
		return
	}
	await mkdir(path.dirname(target), { recursive: true })
	await writeFile(target, map, { flag: 'wx' }).catch((error) => {
		if (error?.code !== 'EEXIST') throw error
	})
}

export default async function (amp: PluginAPI) {
	await seedModels(amp).catch((error) => amp.logger.log(`dmnkstack: could not seed models.md: ${error}`))
	const entries = await readdir(path.join(import.meta.dirname, 'skills'), { withFileTypes: true })
	for (const entry of entries) {
		if (entry.isDirectory()) await amp.registerSkill({ path: `skills/${entry.name}` })
	}
}
