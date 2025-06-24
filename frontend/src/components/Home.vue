.<template>
    <div>
        <header class="header-bar">
            <nav class="nav-bar">
                <div class="header-logo">
                    <a href="/home">ReserveIt.com</a>
                </div>
                <div class="header-buttons">
                    <div class="header-button-group">
                        <a href="/signup">Sign Up</a>
                    </div>
                    <div class="header-button-group">
                        <a href="/login">Sign In</a>
                    </div> 
                </div>
            </nav>
        </header>
        
  </div>
  
</template>

<script>
export default {

}
</script>

<style>
.header-bar {
    --text-color: #D8D9DA;
    --placeholder-text: #646565;
    --box-color: #2e2e2e;
    --box-color-hover: #323232;
    --box-color-active: #767474;
    --anchor-color: #616bdd;
    --anchor-color-active: #424fdb;

    font-family: "Alumni Sans SC", sans-serif;
    background: #3A3A3A;
    position: fixed;
    display: block;
    box-sizing: border-box;
    z-index: auto;
    width: 100vw;
    height: 60px;
    top: 0;
    left: 0;
    margin: 0;
}

.nav-bar {
    box-sizing: border-box;
    justify-content: space-between;
    align-items: center;
    display: flex;
    height: 100%;
    z-index: auto;
}

.header-logo {
    width: 40%;
    text-align: left;
}

.header-logo a {
    margin-left: 3em;
    text-decoration: none;
    color: var(--text-color);
    font-size: 32px;
    padding: 0;
}

.header-buttons {
    width: 60%;
    box-sizing: border-box;
    justify-content: flex-end;
    display: flex;
    margin-right: 5em;
}

.header-button-group {
    height: 40px;
    width: 80px;
    background: var(--box-color);
    margin-left: 10px;
    border-radius: 5px;
    display: flex;
    justify-content: center;
    align-items: center;
}

.header-button-group:hover {
    background: var(--box-color-hover);
}

.header-button-group:focus {
    background: var(--box-color-active);
}

.header-buttons a {
    width: 100%;
    height: 100%;
    font-size: 24px;
    padding-top: 3px;
    color: var(--text-color);
}
</style>