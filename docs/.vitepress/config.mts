import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
	title: "NamedSignal",
	description: "Documentation for NamedSignal — A signal implementation for Luau with a nice balance of ergonomics, performance, and features.",

	base: "/NamedSignal/",
	cleanUrls: true,
	lastUpdated: true,

	themeConfig: {
		// https://vitepress.dev/reference/default-theme-config
		nav: [
			{ text: 'Home', link: '/' },
			{ text: 'API', link: '/api-reference/api-overview' },
			{ text: 'Changelog', link: '/additional-info/changelog' }
		],

		sidebar: [
			{
				text: 'Getting Started',
				items: [
					{ text: 'Introduction', link: '/getting-started/introduction' },
					{ text: 'Installation', link: '/getting-started/installation' },
					{ text: 'Quick Start', link: '/getting-started/quick-start' },
				]
			},
			{
				text: 'API Reference',
				items: [
					{ text: 'API Overview', link: '/api-reference/api-overview' },
					{ text: 'Deferred Mutations', link: '/api-reference/deferred-mutations' },
				]
			},
			{
				text: 'Additional Info',
				items: [
					{ text: 'Performance', link: '/additional-info/performance' },
					{ text: 'Gotchas', link: '/additional-info/gotchas' },
					{ text: 'Gohan\'s Certification', link: '/additional-info/gohans-certification' },
					{ text: 'Changelog', link: "/additional-info/changelog" },
					{ text: 'Future Considerations', link: '/additional-info/future-considerations' },
				]
			}
		],

		socialLinks: [
			{ icon: 'github', link: 'https://github.com/averlyst/NamedSignal' },
			{ icon: 'robloxstudio', link: 'https://devforum.roblox.com/t/4341837' }
		],
		
		search: {
			provider: "local"
		},

		outline: [2, 3],
	},
})
