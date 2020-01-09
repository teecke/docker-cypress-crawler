
describe('example', function() {

 it('test_example', function() {
    cy.viewport(1440, 768)

    cy.visit('https://www.google.es/')
 
    cy.screenshot()
 
 })

})