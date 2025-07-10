"use client";

import { Button } from "./ui/button";
import { GitIcon } from "./icons";
import Link from "next/link";

export const Navbar = () => {
  return (
    <nav className="fixed top-0 w-full border-b border-gray-200 bg-white/75 backdrop-blur-sm dark:bg-gray-900/75 dark:border-gray-800">
      <div className="mx-auto max-w-7xl px-4">
        <div className="flex h-16 items-center justify-between">
          <div className="flex items-center">
            <Link href="/" className="flex items-center gap-2">
              <span className="text-2xl font-bold bg-gradient-to-r from-purple-600 to-indigo-600 bg-clip-text text-transparent">
                ChatDeePT
              </span>
            </Link>
          </div>
          <div className="flex items-center gap-4">
            <Link href="https://www.deepakchopra.com" target="_blank">
              <Button variant="ghost" className="text-gray-700 dark:text-gray-300">
                About Deepak
              </Button>
            </Link>
          </div>
        </div>
      </div>
    </nav>
  );
};
