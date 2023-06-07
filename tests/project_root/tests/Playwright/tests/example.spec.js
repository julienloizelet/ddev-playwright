//ddev-generated
const {test, expect} = require('@playwright/test');

const {
    PAGE_URL,
} = process.env;

test('Visit home page', async ({page}) => {
    await page.goto(PAGE_URL);

    console.log('Opened ' + page.url())
    const html = await page.content();
    console.log(html);
    const content = await page.locator('main');

    await expect(content).toContainText('Playwright is working!');
});
