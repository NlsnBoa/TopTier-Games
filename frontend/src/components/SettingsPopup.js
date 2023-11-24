import React, { Fragment, useContext, useState } from "react";
import { Dialog, Transition } from "@headlessui/react";
import { XMarkIcon } from "@heroicons/react/24/outline";
import { AuthContext } from "../components/Authorizations/AuthContext";

const SettingsPopup = ({ open, setOpen }) => {
  const authContext = useContext(AuthContext);
  const { user, showSuperToast } = authContext;

  const [isEditMode, setIsEditMode] = useState(false);
  const [editedUser, setEditedUser] = useState({
    username: user.username,
    email: user.email,
    firstname: user.firstname,
    lastname: user.lastname,
  });

  const username = editedUser.username;
  const firstname = editedUser.firstname;
  const lastname = editedUser.lastname;
  const email = editedUser.email;

  function buildPath(route) {
    if (process.env.NODE_ENV === "production") {
      return "https://www.toptier.games/" + route;
    } else {
      return "http://localhost:3001/" + route;
    }
  }

  const handleEdit = () => {
    setIsEditMode(true);
  };

  const handleSave = async () => {
    var obj = {
      login: editedUser.username,
      firstname: editedUser.firstname,
      lastname: editedUser.lastname,
      email: editedUser.email,
      userId: user.id,
    };
    var js = JSON.stringify(obj);

    try {
      const response = await fetch(buildPath("Users/api/updateuser"), {
        method: "POST",
        body: js,
        credentials: "include",
        headers: { "Content-Type": "application/json" },
      });

      if (response.status === 200) {
        var res = JSON.parse(await response.text());
        showSuperToast("Updated Info!");
      }
    } catch (e) {
      return;
    }
    setIsEditMode(false);
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setEditedUser((prevUser) => ({ ...prevUser, [name]: value }));
  };

  return (
    <>
      <Transition.Root show={open} as={Fragment}>
        <Dialog as="div" className="relative z-40" onClose={setOpen}>
          <Transition.Child
            as={Fragment}
            enter="ease-out duration-300"
            enterFrom="opacity-0"
            enterTo="opacity-100"
            leave="ease-in duration-200"
            leaveFrom="opacity-100"
            leaveTo="opacity-0"
          >
            <div className="fixed inset-0 hidden bg-gray-800 bg-opacity-75 transition-opacity md:block" />
          </Transition.Child>

          <div className="fixed inset-0 z-10 w-screen overflow-y-auto">
            <div className="flex min-h-full items-stretch justify-center md:items-center md:px-2 lg:px-4">
              <Transition.Child
                as={Fragment}
                enter="ease-out duration-300"
                enterFrom="opacity-0 translate-y-4 md:translate-y-0 md:scale-95"
                enterTo="opacity-100 translate-y-0 md:scale-100"
                leave="ease-in duration-200"
                leaveFrom="opacity-100 translate-y-0 md:scale-100"
                leaveTo="opacity-0 translate-y-4 md:translate-y-0 md:scale-95"
              >
                <Dialog.Panel className="flex w-full transform text-left text-base transition md:my-8 md:max-w-2xl md:px-4 lg:max-w-2xl">
                  <div className="relative flex flex-col w-full h-fit overflow-hidden bg-black rounded-2xl shadow-2xl sm:px-6 sm:pt-8 md:p-6 lg:p- ">
                    <button
                      type="button"
                      className="absolute right-4 top-4 text-gray-400 z-40 hover:text-gray-500 sm:right-6 sm:top-8 md:right-6 md:top-6 lg:right-4 lg:top-4"
                      onClick={() => setOpen(false)}
                    >
                      <span className="sr-only">Close</span>
                      <XMarkIcon className="h-6 w-6" aria-hidden="true" />
                    </button>
                    <h1 className="text-slate-50 italic font-bold text-4xl p-4 mb-4">
                      User Settings
                    </h1>
                    <div className="flex flex-col md:flex-row bg-gray-900 p-4 rounded-md">
                      <div className="mb-4 md:mb-0 md:w-full">
                        <div className="text-sm font-semibold text-gray-500">
                          First Name:
                        </div>
                        {isEditMode ? (
                          <input
                            type="text"
                            name="firstname"
                            value={editedUser.firstname}
                            onChange={handleInputChange}
                            className="p-0 bg-gray-900 text-gray-100 hover:bg-gray-500 rounded-md"
                          />
                        ) : (
                          <div className="text-gray-100">{firstname}</div>
                        )}
                        <div className="text-sm font-semibold text-gray-500">
                          Last Name:
                        </div>
                        {isEditMode ? (
                          <input
                            type="text"
                            name="lastname"
                            value={editedUser.lastname}
                            onChange={handleInputChange}
                            className="p-0 bg-gray-900 text-gray-100 hover:bg-gray-500 rounded-md"
                          />
                        ) : (
                          <div className="text-gray-100">{lastname}</div>
                        )}
                        <div className="text-sm font-semibold text-gray-500">
                          Username:
                        </div>
                        {isEditMode ? (
                          <input
                            type="text"
                            name="username"
                            value={editedUser.username}
                            onChange={handleInputChange}
                            className="p-0 bg-gray-900 text-gray-100 hover:bg-gray-500 rounded-md"
                          />
                        ) : (
                          <div className="text-gray-100">{username}</div>
                        )}
                        <div className="text-sm font-semibold text-gray-500">
                          Email:
                        </div>
                        {isEditMode ? (
                          <input
                            type="text"
                            name="email"
                            value={editedUser.email}
                            onChange={handleInputChange}
                            className="p-0 bg-gray-900 text-gray-100 hover:bg-gray-500 rounded-md"
                          />
                        ) : (
                          <div className="text-gray-100">{email}</div>
                        )}
                      </div>
                      <div className="md:ml-4 md:w-full space-y-2">
                        {isEditMode ? (
                          <button
                            className="bg-blue-500 text-white w-full px-4 py-2 rounded"
                            onClick={handleSave}
                          >
                            Save
                          </button>
                        ) : (
                          <button
                            className="bg-blue-500 text-white w-full px-4 py-2 rounded"
                            onClick={handleEdit}
                          >
                            Edit
                          </button>
                        )}
                        <button
                          className="bg-red-500 text-white w-full px-4 py-2 rounded"
                          onClick={() => showSuperToast("Deleted Account!")}
                        >
                          Delete Account
                        </button>
                      </div>
                    </div>
                  </div>
                </Dialog.Panel>
              </Transition.Child>
            </div>
          </div>
        </Dialog>
      </Transition.Root>
    </>
  );
};

export default SettingsPopup;
