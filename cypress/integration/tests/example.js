const urlList = require("../../fixtures/url_list.json");

let testNumber = 0

describe('crawler', function() {
   urlList.forEach((url) => {
      testNumber++;
      it(`Navigation number ${testNumber}: Visiting URL ${url}`, function() {
         cy.visit(url)
         cy.screenshot(testNumber + "_" + Cypress.moment().format('YYYYMMDD_hhmmss_SSS'))
      });
   });
});