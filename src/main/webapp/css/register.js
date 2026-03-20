const container = document.querySelector('.container');
const registerBtn = document.querySelector('.register-btn');
const loginBtn = document.querySelector('.login-btn');

registerBtn.addEventListener('click', () => {
    container.classList.add('active');
})

loginBtn.addEventListener('click', () => {
    container.classList.remove('active');
})


function toggleProfile(event) {
    event.preventDefault();
    const panel = document.getElementById("profilePanel");
    panel.style.display = panel.style.display === "block" ? "none" : "block";
}

// close when clicking outside
document.addEventListener("click", function(e) {
    const profile = document.querySelector(".profile-menu");
    if (profile && !profile.contains(e.target)) {
        document.getElementById("profilePanel").style.display = "none";
    }
});

