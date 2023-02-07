/* eslint-disable no-undef */
const URL = "https://ddev-playwright-test.ddev.site";

describe(`Should get the correct content`, () => {
    it("Should get the h1 content", async () => {
        await page.goto(`${URL}/home.php`);
        await expect(page).toHaveText("body", "The way is clear!");
    });
});
