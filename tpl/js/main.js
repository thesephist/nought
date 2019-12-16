const {
    StyledComponent,
    router,
} = window.Torus;

class App extends StyledComponent {
    init() {

    }
    compose() {
        return jdom`<div class="app">
            Hello from nought!
            <button>click me</button>
        </div>`;
    }
}

const app = new App();
document.getElementById('app').appendChild(app.node);
