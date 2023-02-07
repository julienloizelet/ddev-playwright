/* eslint-disable no-undef */
const PHP_URL = process.env.PHP_URL;

describe(`Should get the correct content`, () => {
    it("Should get the h1 content", async () => {
        await page.goto(`${PHP_URL}/home.php`);
        await expect(page).toHaveText("body", "The way is clear!");
    });
});
