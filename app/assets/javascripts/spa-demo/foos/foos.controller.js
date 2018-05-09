(function() {
    'use strict';

    angular
        .module('spa-demo.foos')
        .controller('spa-demo.foos.FoosController', FoosController);

    FoosController.$inject = ['spa-demo.Foo'];
    function FoosController(Foo) {
        var vm = this;
        vm.foos;
        vm.foo;

        activate();
        return;
        ////////////////
        function activate() {  }

        function newFoo(){
            vm.Foo = new Foo();
        }
        function handleError(response){
            console.log(response);
        }

        function edit(object, index){}
        function create(){}
        function update(){}
        function remove(){}
        function removeElement(elements, element){}

    }
})();