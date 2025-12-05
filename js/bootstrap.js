import axios from 'axios';
window.axios = axios;

window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
window.axios.defaults.withCredentials = true;

// Attach CSRF token for non-GET requests
const csrfTokenMeta = document.querySelector('meta[name="csrf-token"]');
if (csrfTokenMeta && csrfTokenMeta.content) {
    window.axios.defaults.headers.common['X-CSRF-TOKEN'] = csrfTokenMeta.content;
}

// Axios Request Interceptor: Auto-attach Bearer token from localStorage
axios.interceptors.request.use(
    (config) => {
        const token = localStorage.getItem('auth_token');
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);

// Axios Response Interceptor: Handle 401 Unauthorized (auto logout)
axios.interceptors.response.use(
    (response) => response,
    (error) => {
        if (error.response?.status === 401) {
            // Clear token and redirect to login
            localStorage.removeItem('auth_token');
            localStorage.removeItem('user');
            if (window.location.pathname !== '/login') {
                window.location.href = '/login';
            }
        }
        return Promise.reject(error);
    }
);
