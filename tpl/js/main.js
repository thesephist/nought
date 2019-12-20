const {
    StyledComponent,
    router,
} = window.Torus;

class App extends StyledComponent {
    init() {
        this.count = 1;
    }
    compose() {
        return jdom`<div class="app page-s auto-center">
            Hello from nought!

            <div class="flex flex-row justify-start align-center">
                <p class="mr2">
                    ${this.count} taps
                </p>
                <button onclick="${_ => {
                    this.count++;
                    this.render();
                }}">tap me</button>
            </div>
        </div>`;
    }
}

const app = new App();
document.getElementById('app').appendChild(app.node);
