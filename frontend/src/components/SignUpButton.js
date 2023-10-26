import react from "react";

function SignUpButton() {
  const doSignUp = async (event) => {
    event.preventDefault();
    window.location.href = "/signup";
  };
  return (
    <button
      type="button"
      className="rounded-full bg-white px-24 py-2.5 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50"
      onClick={doSignUp}
    >
      Sign Up
    </button>
  );
}
export default SignUpButton;